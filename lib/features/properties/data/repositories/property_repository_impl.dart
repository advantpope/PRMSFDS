import 'package:hive/hive.dart';
import 'package:property_tax_system_fd/features/properties/data/datasources/property_api.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl({
    required PropertyApi propertyApi,
    Box<PropertyModel>? propertyBox,
  }) : _propertyApi = propertyApi,
       _propertyBox = propertyBox;
  final PropertyApi _propertyApi;
  final Box<PropertyModel>? _propertyBox;

  @override
  Future<List<PropertyModel>> getProperties() async {
    try {
      final response = await _propertyApi.getProperties();
      final properties = response.results;

      // Cache to Hive if available
      if (_propertyBox != null) {
        await _propertyBox.clear();
        for (final property in properties) {
          await _propertyBox.put(property.id, property);
        }
      }

      return properties;
    } catch (e) {
      // Fallback to cached data
      if (_propertyBox != null && _propertyBox.isNotEmpty) {
        return _propertyBox.values.toList();
      }
      rethrow;
    }
  }

  @override
  Future<PropertyModel> getPropertyById(String id) async {
    try {
      final property = await _propertyApi.getPropertyDetail(int.parse(id));

      // Cache to Hive
      if (_propertyBox != null) {
        await _propertyBox.put(property.id, property);
      }

      return property;
    } catch (e) {
      // Try to get from cache
      if (_propertyBox != null) {
        final property = _propertyBox.get(int.parse(id));
        if (property != null) return property;
      }
      rethrow;
    }
  }

  @override
  Future<PropertyModel> addProperty(PropertyModel property) async {
    final createdProperty = await _propertyApi.createProperty(property);

    // Cache to Hive
    if (_propertyBox != null) {
      await _propertyBox.put(createdProperty.id, createdProperty);
    }

    return createdProperty;
  }

  @override
  Future<PropertyModel> updateProperty(PropertyModel property) async {
    final updatedProperty = await _propertyApi.updateProperty(
      property.id,
      property,
    );

    // Update cache
    if (_propertyBox != null) {
      await _propertyBox.put(updatedProperty.id, updatedProperty);
    }

    return updatedProperty;
  }

  @override
  Future<void> deleteProperty(String id) async {
    await _propertyApi.deleteProperty(int.parse(id));

    // Remove from cache
    if (_propertyBox != null) {
      await _propertyBox.delete(int.parse(id));
    }
  }

  @override
  Future<List<PropertyModel>> searchProperties(String query) async {
    return await _propertyApi.searchProperties(query);
  }
}
