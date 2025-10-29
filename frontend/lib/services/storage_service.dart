import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialize storage
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save token
  static Future<bool> saveToken(String token) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('auth_token', token);
  }

  // Get token
  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  // Remove token
  static Future<bool> removeToken() async {
    if (_prefs == null) await init();
    return await _prefs!.remove('auth_token');
  }

  // Alias for removeToken (for backward compatibility)
  static Future<bool> clearToken() async {
    return await removeToken();
  }

  // Save user ID
  static Future<bool> saveUserId(String userId) async {
    if (_prefs == null) await init();
    return await _prefs!.setString('user_id', userId);
  }

  // Get user ID
  static String? getUserId() {
    return _prefs?.getString('user_id');
  }

  // Remove user ID
  static Future<bool> removeUserId() async {
    if (_prefs == null) await init();
    return await _prefs!.remove('user_id');
  }

  // Clear all storage
  static Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // Save string
  static Future<bool> saveString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  // Get string
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Save bool
  static Future<bool> saveBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  // Get bool
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Save int
  static Future<bool> saveInt(String key, int value) async {
    if (_prefs == null) await init();
    return await _prefs!.setInt(key, value);
  }

  // Get int
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }
}

