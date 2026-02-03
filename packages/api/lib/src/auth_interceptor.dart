import 'package:dio/dio.dart';
import 'secure_token_storage.dart';
import 'auth_state.dart';

/// Interceptor that handles automatic token refresh when access token expires
///
/// Flow:
/// 1. Attach access token to all requests
/// 2. On 401 error → try refresh token
/// 3. If refresh succeeds → retry original request
/// 4. If refresh fails → clear storage (user must re-login)
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureTokenStorage _storage = SecureTokenStorage();
  final AuthState _authState = AuthState();

  bool _isRefreshing = false;

  // Callback to handle logout (navigate to login screen)
  final Future<void> Function()? onLogout;

  AuthInterceptor(this._dio, {this.onLogout});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip auth header for login/refresh endpoints
    final skipPaths = ['/auth/login', '/auth/refresh'];
    if (skipPaths.any((path) => options.path.contains(path))) {
      return handler.next(options);
    }

    // Attach access token if available
    final token = _authState.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip retry for login/refresh endpoints
    final skipPaths = ['/auth/login', '/auth/refresh'];
    if (skipPaths.any((path) => err.requestOptions.path.contains(path))) {
      return handler.next(err);
    }

    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null) {
        await _handleLogout();
        return handler.next(err);
      }

      // Call refresh token endpoint
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String?;

        // Update stored tokens
        await _storage.updateAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _storage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            username: _authState.username,
            role: _authState.role,
            userId: _authState.userId,
          );
        }

        // Update in-memory state
        _authState.accessToken = newAccessToken;
        if (newRefreshToken != null) {
          _authState.refreshToken = newRefreshToken;
        }

        // Retry original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dio.fetch(opts);
        return handler.resolve(retryResponse);
      } else {
        await _handleLogout();
        return handler.next(err);
      }
    } catch (e) {
      print('Token refresh failed: $e');
      await _handleLogout();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleLogout() async {
    await _storage.clear();
    _authState.clear();
    if (onLogout != null) {
      await onLogout!();
    }
  }
}
