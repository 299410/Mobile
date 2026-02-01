import 'dart:convert';

/// Simple class to store auth state (token, user info)
/// In production, use secure storage like flutter_secure_storage
class AuthState {
  static final AuthState _instance = AuthState._internal();

  factory AuthState() => _instance;

  AuthState._internal();

  String? accessToken;
  String? refreshToken;
  String? username;
  String? role;

  /// Save tokens after login
  void saveTokens({
    required String accessToken,
    required String refreshToken,
    String? username,
    String? role,
  }) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.username = username;
    this.role = role;
    this.userId = _decodeUserId(accessToken);
  }

  String? userId;

  String? _decodeUserId(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(resp);

      if (payloadMap is Map<String, dynamic>) {
        return payloadMap['userId']?.toString();
      }
      return null;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  /// Clear tokens on logout
  void clear() {
    accessToken = null;
    refreshToken = null;
    username = null;
    role = null;
    userId = null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => accessToken != null;
}
