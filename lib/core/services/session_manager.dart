import 'package:shared_preferences/shared_preferences.dart';

/// A centralized session manager to store and retrieve session-related data.
/// Standardized for unified storage across the application.
class SessionManager {
  final SharedPreferences _prefs;

  /// Single session service (injectable via providers).
  ///
  /// - `SharedPreferences`: non-sensitive session/preferences
  const SessionManager({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  // ─── Constants ───────────────────────────────────────
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _localeKey = 'app_locale';
  static const String _lastSyncKey = 'last_sync';
  static const String _notificationsKey = 'notifications_enabled';
  
  // Branch Selection Keys
  static const String _selectedBranchIdKey = 'selected_branch_id';
  static const String _selectedBranchNameKey = 'selected_branch_name';
  static const String _selectedWarehouseKey = 'selected_warehouse';

  // Auth/Sensitive (now stored in SharedPreferences by request)
  static const String _accessTokenKey = 'erp_access_token';
  static const String _refreshTokenKey = 'erp_refresh_token';
  static const String _userIdKey = 'erp_user_id';
  static const String _tenantIdKey = 'erp_tenant_id';

  // ─── User Data & Auth ────────────────────────────────

  Future<String?> getUserData() async {
    return _prefs.getString(_userDataKey);
  }

  Future<void> setUserData(String userData) async {
    await _prefs.setString(_userDataKey, userData);
  }

  Future<void> clearUserData() async {
    await _prefs.remove(_userDataKey);
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> clearSession() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userDataKey);
    await clearAuth();
  }

  // ─── Auth (stored in SharedPreferences) ─────────────

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  Future<void> saveTenantId(String tenantId) async {
    await _prefs.setString(_tenantIdKey, tenantId);
  }

  Future<String?> getTenantId() async {
    return _prefs.getString(_tenantIdKey);
  }

  Future<void> clearAuth() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_tenantIdKey);
  }

  // ─── Onboarding ─────────────────────────────────────

  Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    await _prefs.setBool(_hasSeenOnboardingKey, seen);
  }

  // ─── Appearance & Locale ────────────────────────────

  Future<bool> isDarkMode() async {
    return _prefs.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_isDarkModeKey, isDark);
  }

  Future<String> getLocale() async {
    return _prefs.getString(_localeKey) ?? 'ar';
  }

  Future<void> setLocale(String locale) async {
    await _prefs.setString(_localeKey, locale);
  }

  // ─── System Settings & Branch Selection ───────────────

  Future<DateTime?> getLastSync() async {
    final ms = _prefs.getInt(_lastSyncKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> setLastSync(DateTime time) async {
    await _prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);
  }

  Future<bool> isNotificationsEnabled() async {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  // ─── Branch Selection Methods ───────────────────────

  Future<int?> getBranchId() async {
    return _prefs.getInt(_selectedBranchIdKey);
  }

  Future<void> setBranchId(int id) async {
    await _prefs.setInt(_selectedBranchIdKey, id);
  }

  Future<String?> getBranchName() async {
    return _prefs.getString(_selectedBranchNameKey);
  }

  Future<void> setBranchName(String name) async {
    await _prefs.setString(_selectedBranchNameKey, name);
  }

  // ─── Warehouse Selection Methods ────────────────────

  Future<String?> getSelectedWarehouse() async {
    return _prefs.getString(_selectedWarehouseKey);
  }

  Future<void> setSelectedWarehouse(String warehouseId) async {
    await _prefs.setString(_selectedWarehouseKey, warehouseId);
  }
}
