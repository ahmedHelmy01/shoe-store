/// ERP System - Preferences Helper
///
/// Wrapper for SharedPreferences providing type-safe
/// access to non-sensitive local settings.
library;

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final SharedPreferences _prefs;

  PreferencesHelper(this._prefs);

  // ─── Keys ──────────────────────────────────────────
  static const _localeKey = 'erp_locale';
  static const _themeKey = 'erp_theme';
  static const _onboardingKey = 'erp_onboarding_done';
  static const _lastSyncKey = 'erp_last_sync';
  static const _notificationsKey = 'erp_notifications_enabled';
  static const _selectedBranchKey = 'erp_selected_branch';
  static const _selectedWarehouseKey = 'erp_selected_warehouse';

  // ─── Locale ────────────────────────────────────────

  String get locale => _prefs.getString(_localeKey) ?? 'ar';
  Future<void> setLocale(String locale) => _prefs.setString(_localeKey, locale);

  // ─── Theme ─────────────────────────────────────────

  String get theme => _prefs.getString(_themeKey) ?? 'light';
  Future<void> setTheme(String theme) => _prefs.setString(_themeKey, theme);
  bool get isDarkMode => theme == 'dark';

  // ─── Onboarding ────────────────────────────────────

  bool get isOnboardingDone => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingKey, true);

  // ─── Sync ──────────────────────────────────────────

  DateTime? get lastSync {
    final ms = _prefs.getInt(_lastSyncKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }
  Future<void> setLastSync(DateTime time) =>
      _prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);

  // ─── Notifications ─────────────────────────────────

  bool get notificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  Future<void> setNotificationsEnabled(bool enabled) =>
      _prefs.setBool(_notificationsKey, enabled);

  // ─── Branch & Warehouse Selection ──────────────────

  String? get selectedBranch => _prefs.getString(_selectedBranchKey);
  Future<void> setSelectedBranch(String branchId) =>
      _prefs.setString(_selectedBranchKey, branchId);

  String? get selectedWarehouse => _prefs.getString(_selectedWarehouseKey);
  Future<void> setSelectedWarehouse(String warehouseId) =>
      _prefs.setString(_selectedWarehouseKey, warehouseId);

  // ─── Clear All ─────────────────────────────────────

  Future<void> clearAll() => _prefs.clear();
}
