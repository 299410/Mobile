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

      // Lưu tokens vào AuthState
      _authState.saveTokens(
        accessToken: response.data['accessToken'] ?? '',
        refreshToken: response.data['refreshToken'] ?? '',
        username: response.data['username'],
        role: response.data['role'],
      );

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
      _authState.clear();
    }
  }
}
