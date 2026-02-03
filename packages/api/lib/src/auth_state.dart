import 'dart:convert';
import 'secure_token_storage.dart';

/// Simple class to store auth state (token, user info)
/// Now syncs with SecureTokenStorage for persistence
class AuthState {
  static final AuthState _instance = AuthState._internal();

  factory AuthState() => _instance;

  AuthState._internal();

  final SecureTokenStorage _storage = SecureTokenStorage();

  String? accessToken;
  String? refreshToken;
  String? username;
  String? role;
  String? userId;
  String? lecturerId;

  /// Initialize from secure storage (call on app start)
  Future<void> initFromStorage() async {
    accessToken = await _storage.getAccessToken();
    refreshToken = await _storage.getRefreshToken();

    final userInfo = await _storage.getUserInfo();
    if (userInfo != null) {
      username = userInfo['username'];
      role = userInfo['role'];
      userId = userInfo['userId'];
      lecturerId = userInfo['lecturerId'];
    }
  }

  /// Save tokens after login (both in-memory and persistent)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? username,
    String? role,
    String? lecturerId,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.username = username;
    this.role = role;
    this.userId = _decodeUserId(accessToken);
    this.lecturerId = lecturerId;

    // Persist to secure storage
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      role: role,
      userId: this.userId,
      lecturerId: lecturerId,
    );
  }

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

  /// Clear tokens on logout (both in-memory and persistent)
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    username = null;
    role = null;
    userId = null;
    lecturerId = null;

    await _storage.clear();
  }

  /// Check if user is logged in
  bool get isLoggedIn => accessToken != null;

  /// Check if has valid stored tokens (for auto-login)
  Future<bool> hasStoredTokens() async {
    return await _storage.hasValidTokens();
  }
}
