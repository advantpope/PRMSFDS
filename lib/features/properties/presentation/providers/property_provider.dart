import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:property_tax_system_fd/core/config/app_constants.dart';
import 'package:property_tax_system_fd/features/properties/data/datasources/property_api.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/data/repositories/property_repository_impl.dart';
import 'package:property_tax_system_fd/features/properties/domain/repositories/property_repository.dart';

// Create PropertyRepository
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepositoryImpl(
    propertyApi: PropertyApi(),
    propertyBox: Hive.box<PropertyModel>(AppConstants.propertiesBox),
  );
});

// Main provider
final propertyProvider =
    StateNotifierProvider<PropertyNotifier, AsyncValue<List<PropertyModel>>>(
      (ref) => PropertyNotifier(ref.read(propertyRepositoryProvider)),
    );

// Property detail provider
final propertyDetailProvider = FutureProvider.family<PropertyModel?, String>((
  ref,
  propertyId,
) async {
  try {
    final repository = ref.read(propertyRepositoryProvider);
    return await repository.getPropertyById(propertyId);
  } catch (e) {
    return null;
  }
});

class PropertyNotifier extends StateNotifier<AsyncValue<List<PropertyModel>>> {
  final PropertyRepository _repository;

  PropertyNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProperties();
  }

  Future<void> loadProperties({bool refresh = false}) async {
    if (!refresh && state.hasValue) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      final properties = await _repository.getProperties();
      state = AsyncValue.data(properties);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<PropertyModel> addProperty(PropertyModel property) async {
    try {
      final createdProperty = await _repository.addProperty(property);

      // Update local state
      final currentProperties = state.value ?? [];
      state = AsyncValue.data([...currentProperties, createdProperty]);

      return createdProperty;
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    try {
      await _repository.updateProperty(property);

      // Update local state
      final currentProperties = state.value ?? [];
      final index = currentProperties.indexWhere((p) => p.id == property.id);
      if (index != -1) {
        final updatedList = List<PropertyModel>.from(currentProperties);
        updatedList[index] = property;
        state = AsyncValue.data(updatedList);
      }
    } catch (e) {
      throw Exception('Failed to update property: $e');
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await _repository.deleteProperty(propertyId);

      // Update local state
      final currentProperties = state.value ?? [];
      final updatedList = currentProperties
          .where((p) => p.id.toString() != propertyId)
          .toList();
      state = AsyncValue.data(updatedList);
    } catch (e) {
      throw Exception('Failed to delete property: $e');
    }
  }

  Future<List<PropertyModel>> searchProperties(String query) async {
    try {
      return await _repository.searchProperties(query);
    } catch (e) {
      throw Exception('Failed to search properties: $e');
    }
  }
}
