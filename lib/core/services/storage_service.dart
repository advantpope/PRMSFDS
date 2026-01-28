import 'package:hive/hive.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> saveString(String key, String value) async {
    final box = await Hive.openBox('app_data');
    await box.put(key, value);
  }

  Future<String?> getString(String key) async {
    final box = await Hive.openBox('app_data');
    return box.get(key);
  }

  Future<void> saveObject(String key, dynamic object) async {
    final box = await Hive.openBox('app_data');
    await box.put(key, object);
  }

  Future<dynamic> getObject(String key) async {
    final box = await Hive.openBox('app_data');
    return box.get(key);
  }

  Future<void> clearAll() async {
    final box = await Hive.openBox('app_data');
    await box.clear();
  }
}