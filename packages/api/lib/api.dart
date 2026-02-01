import 'package:dio/dio.dart';

// Export các API classes
export 'src/auth_api.dart';
export 'src/auth_state.dart';
export 'src/lecturer_api.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8080/api'; // Base URL

  static Dio createDio() {
    return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
  }
}
