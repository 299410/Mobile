import 'package:dio/dio.dart';
import 'src/auth_interceptor.dart';
import 'src/auth_state.dart';

// Export các API classes
export 'src/auth_api.dart';
export 'src/auth_state.dart';
export 'src/lecturer_api.dart';
export 'src/secure_token_storage.dart';
export 'src/auth_interceptor.dart';

class ApiClient {
  static const String baseUrl =
      'https://capstone-def-scheduler-2c34f80201f6.herokuapp.com/api'; // Base URL

  static Dio? _dio;
  static Future<void> Function()? _onLogout;

  /// Set logout callback (call from main.dart to handle navigation)
  static void setLogoutCallback(Future<void> Function() callback) {
    _onLogout = callback;
  }

  /// Initialize auth state from storage (call on app start)
  static Future<void> init() async {
    await AuthState().initFromStorage();
  }

  static Dio createDio() {
    if (_dio != null) return _dio!;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    // Add auth interceptor for automatic token refresh
    _dio!.interceptors.add(AuthInterceptor(_dio!, onLogout: _onLogout));

    return _dio!;
  }
}
