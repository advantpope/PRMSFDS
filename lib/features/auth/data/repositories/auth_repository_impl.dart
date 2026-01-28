import 'package:property_tax_system_fd/features/auth/data/datasources/auth_api.dart';
import 'package:property_tax_system_fd/features/auth/domain/repositories/auth_repository.dart';
import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';
import 'package:property_tax_system_fd/shared/services/storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final StorageService _storageService;

  AuthRepositoryImpl({
    required AuthApi authApi,
    required StorageService storageService,
  }) : _authApi = authApi,
       _storageService = storageService;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _authApi.login(request);

    // Save tokens
    await _storageService.saveAuthToken(response.accessToken);
    await _storageService.saveRefreshToken(response.refreshToken);
    await _storageService.saveUserData(response.user.toJson());

    return response;
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _authApi.register(request);

    // Save tokens
    await _storageService.saveAuthToken(response.accessToken);
    await _storageService.saveRefreshToken(response.refreshToken);
    await _storageService.saveUserData(response.user.toJson());

    return response;
  }

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } finally {
      await clearAuthData();
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final newToken = await _authApi.refreshToken(refreshToken);
    await _storageService.saveAuthToken(newToken);
    return newToken;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final userData = await _storageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }

    // If not in storage, fetch from API
    final user = await _authApi.getCurrentUser();
    await _storageService.saveUserData(user.toJson());
    return user;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _authApi.resetPassword(email);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearAuthData() async {
    await _storageService.clearAllData();
  }
}
