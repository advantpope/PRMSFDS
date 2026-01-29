import 'package:hive/hive.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';

class PropertyLocalDataSource {
  final Box<PropertyModel> propertyBox;

  PropertyLocalDataSource(this.propertyBox);

  Future<List<PropertyModel>> getProperties() async {
    return propertyBox.values.toList();
  }

  Future<void> saveProperties(List<PropertyModel> properties) async {
    await propertyBox.clear();
    for (final property in properties) {
      await propertyBox.put(property.id, property);
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    await propertyBox.put(property.id, property);
  }
}
