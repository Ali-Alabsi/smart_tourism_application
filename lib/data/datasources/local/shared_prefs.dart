import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  static SharedPreferences? _prefs;

  factory SharedPrefs() {
    return _instance;
  }

  SharedPrefs._internal();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> setString(String key, String value) async {
    final p = await prefs;
    await p.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    final p = await prefs;
    await p.setBool(key, value);
  }

  Future<String?> getString(String key) async {
    final p = await prefs;
    return p.getString(key);
  }

  Future<bool?> getBool(String key) async {
    final p = await prefs;
    return p.getBool(key);
  }

  Future<void> remove(String key) async {
    final p = await prefs;
    await p.remove(key);
  }

  Future<void> clear() async {
    final p = await prefs;
    await p.clear();
  }
}