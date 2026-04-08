import 'package:shared_preferences/shared_preferences.dart';

/// A centralized session manager to store and retrieve session-related data.
/// Standardized for unified storage across the application.
class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();

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

  // ─── User Data & Auth ────────────────────────────────

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataKey);
  }

  Future<void> setUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userDataKey);
  }

  // ─── Onboarding ─────────────────────────────────────

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, seen);
  }

  // ─── Appearance & Locale ────────────────────────────

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey) ?? 'ar';
  }

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  // ─── System Settings & Branch Selection ───────────────

  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSyncKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> setLastSync(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  // ─── Branch Selection Methods ───────────────────────

  Future<int?> getBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedBranchIdKey);
  }

  Future<void> setBranchId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedBranchIdKey, id);
  }

  Future<String?> getBranchName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedBranchNameKey);
  }

  Future<void> setBranchName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedBranchNameKey, name);
  }

  // ─── Warehouse Selection Methods ────────────────────

  Future<String?> getSelectedWarehouse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedWarehouseKey);
  }

  Future<void> setSelectedWarehouse(String warehouseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedWarehouseKey, warehouseId);
  }
}
