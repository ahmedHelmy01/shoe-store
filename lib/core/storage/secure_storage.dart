/// ERP System - Secure Storage
///
/// Manages secure storage for authentication tokens
/// and sensitive user data using flutter_secure_storage.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;
  final String baseUrl;

  SecureStorage({required this.baseUrl})
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  // ─── Keys ──────────────────────────────────────────
  static const _accessTokenKey = 'erp_access_token';
  static const _refreshTokenKey = 'erp_refresh_token';
  static const _userIdKey = 'erp_user_id';
  static const _userDataKey = 'erp_user_data';
  static const _tenantIdKey = 'erp_tenant_id';

  // ─── Token Management ──────────────────────────────

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> get hasToken async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─── User Data ─────────────────────────────────────

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> saveUserData(String userJson) async {
    await _storage.write(key: _userDataKey, value: userJson);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  // ─── Tenant ────────────────────────────────────────

  Future<void> saveTenantId(String tenantId) async {
    await _storage.write(key: _tenantIdKey, value: tenantId);
  }

  Future<String?> getTenantId() async {
    return await _storage.read(key: _tenantIdKey);
  }

  // ─── Clear All ─────────────────────────────────────

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
