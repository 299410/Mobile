import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistent storage for authentication tokens
/// Tokens persist across app restarts until user explicitly logs out
class SecureTokenStorage {
  static final SecureTokenStorage _instance = SecureTokenStorage._internal();
  factory SecureTokenStorage() => _instance;
  SecureTokenStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Storage keys
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserInfo = 'user_info';

  /// Save tokens after successful login
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? username,
    String? role,
    String? userId,
    String? lecturerId,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);

    // Save user info as JSON
    final userInfo = {
      'username': username,
      'role': role,
      'userId': userId,
      'lecturerId': lecturerId,
    };
    await _storage.write(key: _keyUserInfo, value: jsonEncode(userInfo));
  }

  /// Update only access token (after refresh)
  Future<void> updateAccessToken(String accessToken) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Get stored user info
  Future<Map<String, dynamic>?> getUserInfo() async {
    final json = await _storage.read(key: _keyUserInfo);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  /// Clear all stored tokens (on logout)
  Future<void> clear() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserInfo);
  }

  /// Check if valid tokens exist
  Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}
