import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // Auth token methods
  Future<String?> getAuthToken() async {
    return await _storage.read(key: authTokenKey);
  }

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: authTokenKey, value: token);
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: authTokenKey);
  }

  // Refresh token methods
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: refreshTokenKey, value: token);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: refreshTokenKey);
  }

  // User ID methods
  Future<String?> getUserId() async {
    return await _storage.read(key: userIdKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: userIdKey, value: userId);
  }

  Future<void> deleteUserId() async {
    await _storage.delete(key: userIdKey);
  }

  // Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
