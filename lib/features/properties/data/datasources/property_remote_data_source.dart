import 'package:dio/dio.dart';
import 'package:property_tax_system_fd/core/config/app_constants.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';

class PropertyRemoteDataSource {
  PropertyRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PropertyModel>> getProperties() async {
    try {
      final response = await _dio.get(
        '${AppConstants.apiBaseUrl}/api/properties/',
      );

      final List<dynamic> data = response.data['results'];
      return data.map((json) => PropertyModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch properties: $e');
    }
  }

  Future<PropertyModel> createProperty(PropertyModel property) async {
    try {
      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/api/properties/',
        data: property.toJson(),
      );

      return PropertyModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create property: $e');
    }
  }

  Future<String> uploadPropertyImage(
    String propertyId,
    String imagePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'property': propertyId,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/api/property-images/',
        data: formData,
      );

      return response.data['image_url'];
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
