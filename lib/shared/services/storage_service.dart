import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  factory StorageService() => _instance;

  StorageService._internal();
  static final StorageService _instance = StorageService._internal();

  Future<Box> _openBox(String name) async {
    if (kIsWeb) {
      return await Hive.openBox(name);
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    return await Hive.openBox(name, path: path);
  }

  // Auth methods
  Future<void> saveAuthToken(String token) async {
    final box = await _openBox('auth_data');
    await box.put('auth_token', token);
  }

  Future<String?> getAuthToken() async {
    final box = await _openBox('auth_data');
    return box.get('auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    final box = await _openBox('auth_data');
    await box.put('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    final box = await _openBox('auth_data');
    return box.get('refresh_token');
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final box = await _openBox('user_data');
    await box.put('profile', data);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final box = await _openBox('user_data');
    return box.get('profile');
  }

  Future<void> saveUserPreferences(Map<String, dynamic> prefs) async {
    final box = await _openBox('user_prefs');
    await box.put('preferences', prefs);
  }

  Future<Map<String, dynamic>?> getUserPreferences() async {
    final box = await _openBox('user_prefs');
    return box.get('preferences');
  }

  Future<void> clearAllData() async {
    final boxes = ['auth_data', 'user_data', 'user_prefs', 'cached_data'];

    for (final boxName in boxes) {
      final box = await _openBox(boxName);
      await box.clear();
    }
  }

  // App settings
  Future<void> saveAppSetting(String key, dynamic value) async {
    final box = await _openBox('app_settings');
    await box.put(key, value);
  }

  Future<dynamic> getAppSetting(String key, {dynamic defaultValue}) async {
    final box = await _openBox('app_settings');
    return box.get(key, defaultValue: defaultValue);
  }

  // Offline data
  Future<void> saveOfflineData(String key, dynamic data) async {
    final box = await _openBox('offline_queue');
    await box.put(key, data);
  }

  Future<List<dynamic>> getOfflineData() async {
    final box = await _openBox('offline_queue');
    return box.values.toList();
  }

  Future<void> removeOfflineData(String key) async {
    final box = await _openBox('offline_queue');
    await box.delete(key);
  }

  // Theme and language
  Future<void> saveThemeMode(String mode) async {
    await saveAppSetting('theme_mode', mode);
  }

  Future<String> getThemeMode() async {
    return await getAppSetting('theme_mode', defaultValue: 'light');
  }

  Future<void> saveLanguage(String language) async {
    await saveAppSetting('language', language);
  }

  Future<String> getLanguage() async {
    return await getAppSetting('language', defaultValue: 'en');
  }
}
