import 'package:dio/dio.dart';
import 'package:models/models.dart';
import '../api.dart';
import 'auth_state.dart';

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
      final userId = _authState.userId; // Get userId from token

      if (userId == null) {
        print('Warning: UserId is null in AuthState');
      }

      final dateString = date.toIso8601String().split('T')[0]; // yyyy-MM-dd

      if (isAvailable) {
        // REGISTER
        await _dio.post(
          '/v1/availability',
          data: {
            'userId':
                userId, // Send userId instead of lecturerId since we updated backend
            'username': _authState.username, // Fallback if userId is missing
            // 'lecturerId': ... (no longer needed if userId is present)
            'roundId': roundId,
            'availableDate': dateString,
          },
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null,
        );
      } else {
        // UNREGISTER (DELETE)
        await _dio.delete(
          '/v1/availability/lecturer/$userId/round/$roundId/date/$dateString',
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null,
        );
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
        return data.map((json) {
          return DefenseSchedule(
            id: json['assignmentId']?.toString() ?? '',
            lecturerId: lecturerId, // Keep passing the requested ID or use 'me'
            date: DateTime.parse(json['defenseDate']),
            slot: json['blockName'] ?? 'Unknown Slot',
            role: json['roleName'] ?? 'Unknown Role',
            details: 'Room TBD', // Backend response doesn't include room yet
          );
        }).toList();
      } else {
        throw Exception('Failed to load schedule');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
