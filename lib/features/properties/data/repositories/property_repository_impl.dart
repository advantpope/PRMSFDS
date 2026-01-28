import 'package:property_tax_system_fd/features/properties/domain/entities/property.dart';
import 'package:property_tax_system_fd/features/properties/domain/repositories/property_repository.dart';
import 'package:property_tax_system_fd/features/properties/data/datasources/property_local_data_source.dart';
import 'package:property_tax_system_fd/features/properties/data/datasources/property_remote_data_source.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource remoteDataSource;
  final PropertyLocalDataSource localDataSource;

  PropertyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Property>> getProperties() async {
    // Try remote first, then local if remote fails
    try {
      final remoteProperties = await remoteDataSource.getProperties();
      // Save to local
      await localDataSource.saveProperties(remoteProperties);
      return remoteProperties;
    } catch (e) {
      // If remote fails, get from local
      return localDataSource.getProperties();
    }
  }

  @override
  Future<Property> addProperty(Property property) async {
    // Add to remote and then to local
    final addedProperty = await remoteDataSource.addProperty(property);
    await localDataSource.addProperty(addedProperty);
    return addedProperty;
  }

  // ... other methods
}
