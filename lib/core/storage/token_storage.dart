import 'package:shared_preferences/shared_preferences.dart';

/// Simple token storage using SharedPreferences
class TokenStorage {
  static const String _tokenKey = 'auth_token';

  static TokenStorage? _instance;
  static TokenStorage get instance => _instance ??= TokenStorage._();
  TokenStorage._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _preferences;
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await _preferences;
    await prefs.remove(_tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
