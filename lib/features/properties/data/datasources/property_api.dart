import 'package:dio/dio.dart';
import 'package:property_tax_system_fd/core/network/api_client.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/core/network/api_response.dart';

class PropertyApi {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<PropertyModel>> getProperties({
    int page = 1,
    int pageSize = 20,
    Map<String, dynamic>? filters,
  }) async {
    final queryParams = {'page': page, 'page_size': pageSize, ...?filters};

    final response = await _apiClient.get(
      ApiEndpoints.properties,
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => PropertyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PropertyModel> getPropertyDetail(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.propertyDetail(id.toString()),
    );

    return PropertyModel.fromJson(response.data);
  }

  Future<PropertyModel> createProperty(PropertyModel property) async {
    final response = await _apiClient.post(
      ApiEndpoints.properties,
      data: property.toJson(),
    );

    return PropertyModel.fromJson(response.data);
  }

  Future<PropertyModel> updateProperty(int id, PropertyModel property) async {
    final response = await _apiClient.put(
      ApiEndpoints.propertyDetail(id.toString()),
      data: property.toJson(),
    );

    return PropertyModel.fromJson(response.data);
  }

  Future<void> deleteProperty(int id) async {
    await _apiClient.delete(ApiEndpoints.propertyDetail(id.toString()));
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

  Future<String> uploadPropertyImage(int propertyId, String imagePath) async {
    final formData = FormData.fromMap({
      'property': propertyId,
      'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _apiClient.post(
      ApiEndpoints.propertyUploadImage,
      data: formData,
    );

    return response.data['image_url'];
  }
}
