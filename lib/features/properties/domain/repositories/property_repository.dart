import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';

abstract class PropertyRepository {
  Future<List<PropertyModel>> getProperties();
  Future<PropertyModel> getPropertyById(String id);
  Future<PropertyModel> addProperty(PropertyModel property);
  Future<PropertyModel> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);
  Future<List<PropertyModel>> searchProperties(String query);
}
