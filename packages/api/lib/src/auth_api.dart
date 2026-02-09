import 'package:dio/dio.dart';
import 'package:models/models.dart';
import '../api.dart';
import 'auth_state.dart';

class AuthApi {
  final Dio _dio;
  final AuthState _authState = AuthState();

  // Sử dụng ApiClient.createDio() để có config thống nhất
  AuthApi() : _dio = ApiClient.createDio();

  /// Login với username và password
  /// Trả về [User] nếu thành công, throw Exception nếu lỗi
  Future<User> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      print('=== LOGIN RESPONSE ===');
      print(response.data);
      print('======================');

      final accessToken = response.data['accessToken'] ?? '';
      final refreshToken = response.data['refreshToken'] ?? '';

      // Thử lấy lecturerId trực tiếp từ response login
      String? lecturerId = response.data['lecturerId']?.toString();

      // Nếu không thấy ở root, thử tìm trong object 'user' hoặc 'lecturerInfo'
      if (lecturerId == null) {
        if (response.data['user'] != null) {
          lecturerId = response.data['user']['lecturerId']?.toString();
        } else if (response.data['lecturerInfo'] != null) {
          lecturerId = response.data['lecturerInfo']['lecturerId']?.toString();
        }
      }

      print('DEBUG: Login response lecturerId: $lecturerId');

      // Lưu tokens (kèm lecturerId nếu có)
      await _authState.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        username: response.data['username'],
        role: response.data['role'],
        lecturerId: lecturerId,
      );

      // Chỉ gọi API profile nếu chưa có lecturerId
      if (lecturerId == null) {
        try {
          print('DEBUG: Fetching profile to find lecturerId...');
          final profileResponse = await _dio.get(
            '/v1/users/me',
            options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          );

          if (profileResponse.statusCode == 200) {
            final lecturerInfo = profileResponse.data['lecturerInfo'];
            if (lecturerInfo != null) {
              lecturerId = lecturerInfo['lecturerId']?.toString();
              print('DEBUG: Got lecturerId from profile: $lecturerId');

              // Cập nhật lại state với lecturerId mới tìm được
              if (lecturerId != null) {
                await _authState.saveTokens(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  username: response.data['username'],
                  role: response.data['role'],
                  lecturerId: lecturerId,
                );
              }
            }
          }
        } catch (e) {
          print('Warning: Could not fetch profile for lecturerId: $e');
          // Không throw lỗi ở đây để user vẫn login được (dù có thể thiếu lecturerId)
        }
      }

      final userData = response.data['user'] ?? response.data;
      return User.fromJson(userData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Tài khoản hoặc mật khẩu không đúng!');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối quá chậm. Vui lòng thử lại.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối đến server!');
      } else {
        throw Exception('Đã có lỗi xảy ra: ${e.message}');
      }
    }
  }

  /// Refresh token - get new access token using refresh token
  Future<bool> refreshToken() async {
    final refreshToken = _authState.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        await _authState.saveTokens(
          accessToken: response.data['accessToken'] ?? '',
          refreshToken: response.data['refreshToken'] ?? refreshToken,
          username: _authState.username,
          role: _authState.role,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token failed: $e');
      return false;
    }
  }

  /// Logout - gọi API logout với accessToken trong header
  Future<void> logout() async {
    final token = _authState.accessToken;

    try {
      await _dio.post(
        '/auth/logout',
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      print('=== LOGOUT SUCCESS ===');
    } on DioException catch (e) {
      print('Logout API error: ${e.message}');
    } finally {
      // Luôn clear local state dù API thành công hay không
      await _authState.clear();
    }
  }
}
