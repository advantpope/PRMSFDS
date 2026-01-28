// lib/core/services/token_storage.dart
import 'package:property_tax_system_fd/core/services/storage_service.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';

  final StorageService _storageService = StorageService();

  Future<void> saveToken(String token) async {
    await _storageService.saveString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await _storageService.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    await _storageService.saveString(_tokenKey, '');
  }
}
