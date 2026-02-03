import 'package:dio/dio.dart';
import 'package:models/models.dart';
import '../api.dart';

class LecturerApi {
  final Dio _dio;
  final AuthState _authState = AuthState();

  LecturerApi() : _dio = ApiClient.createDio();

  // Fetch Defense Rounds from API
  Future<List<DefenseRound>> getDefenseRounds() async {
    try {
      final token = _authState.accessToken;
      final response = await _dio.get(
        '/v1/rounds',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;
        List<dynamic> list;

        if (data is List) {
          list = data;
        } else if (data is Map && data['content'] is List) {
          // Spring Boot Page<T>
          list = data['content'];
        } else if (data is Map && data['data'] is List) {
          // General ApiResponse
          list = data['data'];
        } else {
          print('API Response: $data');
          throw Exception(
              'API response format not supported (expected List, or Object with "content"/"data")');
        }

        return list.map((json) {
          return DefenseRound(
            id: json['roundId']?.toString() ?? '',
            name: json['roundName'] ?? 'Unknown Round',
            status: json['status'] ?? 'UNKNOWN',
          );
        }).toList();
      } else {
        throw Exception('Failed to load defense rounds');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<DefenseDay>> getDefenseDays(String roundId) async {
    try {
      final token = _authState.accessToken;
      final response = await _dio.get(
        '/v1/rounds/$roundId/days',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          return DefenseDay(
            id: json['dayId']?.toString() ?? '',
            date: DateTime.parse(json['defenseDate']),
            roundId: json['roundId']?.toString() ?? roundId,
          );
        }).toList();
      } else {
        throw Exception('Failed to load defense days');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> registerAvailability(
      String roundId, DateTime date, bool isAvailable) async {
    try {
      final token = _authState.accessToken;
      final userId = _authState.userId;
      final lecturerId = _authState.lecturerId;

      if (userId == null) {
        print('Warning: UserId is null in AuthState');
      }

      final dateString = date.toIso8601String().split('T')[0]; // yyyy-MM-dd

      if (isAvailable) {
        // REGISTER - uses userId (backend will lookup lecturerId)
        await _dio.post(
          '/v1/availability',
          data: {
            'userId': userId,
            'username': _authState.username, // Fallback if userId is missing
            'roundId': roundId,
            'availableDate': dateString,
          },
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null,
        );
      } else {
        // UNREGISTER (DELETE) - uses lecturerId as expected by backend
        if (lecturerId == null) {
          throw Exception('Lecturer ID not found. Please re-login.');
        }
        await _dio.delete(
          '/v1/availability/lecturer/$lecturerId/round/$roundId/date/$dateString',
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null,
        );
      }
    } on DioException catch (e) {
      // Extract error message from backend response
      String errorMessage = 'Network error';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          // Try common error message fields
          errorMessage = data['message'] ??
              data['error'] ??
              data['reason'] ??
              e.message ??
              'Unknown error';
        } else if (data is String) {
          errorMessage = data;
        }
      } else {
        errorMessage = e.message ?? 'Network error';
      }
      throw Exception(errorMessage);
    }
  }

  Future<List<DateTime>> getLecturerAvailability(String roundId) async {
    try {
      final token = _authState.accessToken;
      final lecturerId = _authState.lecturerId;

      if (lecturerId == null) {
        throw Exception('Lecturer ID not found. Please re-login.');
      }

      final response = await _dio.get(
        '/v1/availability/lecturer/$lecturerId/round/$roundId',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          // Assuming response is a list of objects with 'availableDate' or similar
          // Adjust based on actual API response structure if needed.
          // If it returns list of strings "2024-06-15":
          if (json is String) return DateTime.parse(json);

          // If it returns objects:
          return DateTime.parse(json['availableDate']);
        }).toList();
      } else {
        throw Exception('Failed to load registered availability');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<DefenseSchedule>> getSchedule(String lecturerId) async {
    try {
      final token = _authState.accessToken;
      final response = await _dio.get(
        '/v1/lecturers/me/schedule',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => DefenseSchedule.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schedule');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = _authState.accessToken;

      // Using /v1/users/me as requested
      const String endpoint = '/v1/users/me';
      print('DEBUG: Calling endpoint: $endpoint');
      print(
          'DEBUG: Token is ${token == null ? "NULL!" : "present (${token.substring(0, 20)}...)"}');

      if (token == null) {
        throw Exception('Not authenticated - no access token');
      }

      final response = await _dio.get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DEBUG: API Error: ${e.message}, Response: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    }
  }
}
