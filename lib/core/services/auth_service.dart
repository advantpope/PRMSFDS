import 'package:property_tax_system_fd/core/network/api_service.dart';
import 'package:property_tax_system_fd/shared/services/storage_service.dart';
import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<AuthResponse> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final response = await _apiService.login(request);

    // Save tokens and user data
    await _storageService.saveAuthToken(response.accessToken);
    await _storageService.saveRefreshToken(response.refreshToken);
    await _storageService.saveUserData(response.user.toJson());

    return response;
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    final request = RegisterRequest(
      username: username,
      email: email,
      password1: password,
      password2: confirmPassword,
      firstName: firstName,
      lastName: lastName,
    );

    final response = await _apiService.register(request);

    // Save tokens and user data
    await _storageService.saveAuthToken(response.accessToken);
    await _storageService.saveRefreshToken(response.refreshToken);
    await _storageService.saveUserData(response.user.toJson());

    return response;
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } finally {
      await _storageService.clearAllData();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storageService.getAuthToken();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    return await _storageService.getUserData();
  }

  Future<String> refreshToken() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final newToken = await _apiService.refreshToken(refreshToken);
    await _storageService.saveAuthToken(newToken);
    return newToken;
  }
}
