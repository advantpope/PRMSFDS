import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> logout();
  Future<String> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<void> resetPassword(String email);
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}
