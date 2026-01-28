import 'package:dio/dio.dart';
import 'package:property_tax_system_fd/core/network/api_client.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid username or password');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errors = e.response?.data;
        if (errors is Map) {
          if (errors.containsKey('username')) {
            throw Exception('Username already exists');
          } else if (errors.containsKey('email')) {
            throw Exception('Email already exists');
          } else if (errors.containsKey('password1')) {
            throw Exception(errors['password1'].join(', '));
          }
        }
      }
      throw Exception('Registration failed: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Silently fail logout if there's an error
      print('Logout error: $e');
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken},
      );

      return response.data['access'];
    } catch (e) {
      throw Exception('Token refresh failed');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/user/');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user data');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _apiClient.post('/auth/password/reset/', data: {'email': email});
    } catch (e) {
      throw Exception('Failed to reset password');
    }
  }
}
