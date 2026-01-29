import 'package:dio/dio.dart';
import 'package:property_tax_system_fd/core/network/api_client.dart';
import 'package:property_tax_system_fd/core/network/api_response.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/auth/data/models/auth_response.dart';
import 'package:property_tax_system_fd/features/auth/data/models/login_request.dart';
import 'package:property_tax_system_fd/features/auth/data/models/register_request.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();

  // Auth methods
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
  }

  // Property methods
  Future<ApiResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.properties,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => PropertyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PropertyModel> getPropertyById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.propertyDetail(id));
    return PropertyModel.fromJson(response.data);
  }

  Future<PropertyModel> createProperty(PropertyModel property) async {
    final response = await _apiClient.post(
      ApiEndpoints.properties,
      data: property.toJson(),
    );
    return PropertyModel.fromJson(response.data);
  }

  Future<PropertyModel> updateProperty(PropertyModel property) async {
    final response = await _apiClient.put(
      ApiEndpoints.propertyDetail(property.id.toString()),
      data: property.toJson(),
    );
    return PropertyModel.fromJson(response.data);
  }

  Future<void> deleteProperty(String id) async {
    await _apiClient.delete(ApiEndpoints.propertyDetail(id));
  }

  Future<List<PropertyModel>> searchProperties(String query) async {
    final response = await _apiClient.get(
      ApiEndpoints.propertySearch,
      queryParameters: {'q': query},
    );
    final data = response.data as List;
    return data
        .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Refresh token
  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refresh': refreshToken},
    );
    return response.data['access'];
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _apiClient.get('/auth/user/');
    return response.data;
  }
}
