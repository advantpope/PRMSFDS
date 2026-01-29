import 'package:property_tax_system_fd/core/network/api_client.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/features/ownership/data/models/ownership_model.dart';

class OwnershipApi {
  final ApiClient _apiClient = ApiClient();

  // Get ownership records
  Future<List<OwnershipModel>> getOwnershipRecords({
    int page = 1,
    int pageSize = 20,
    String? propertyId,
  }) async {
    final queryParams = {
      'page': page,
      'page_size': pageSize,
      if (propertyId != null) 'property_id': propertyId,
    };

    final response = await _apiClient.get(
      ApiEndpoints.ownership,
      queryParameters: queryParams,
    );

    final data = response.data as List;
    return data
        .map((json) => OwnershipModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Get ownership detail
  Future<OwnershipModel> getOwnershipDetail(String id) async {
    final response = await _apiClient.get(ApiEndpoints.ownershipDetail(id));
    return OwnershipModel.fromJson(response.data);
  }

  // Transfer ownership
  Future<OwnershipModel> transferOwnership({
    required String propertyId,
    required String newOwnerName,
    required String newOwnerPhone,
    required String transferType,
    required DateTime transferDate,
    required String documentNumber,
    String? newOwnerEmail,
    String? newOwnerAddress,
    String? transferReason,
    String? comments,
  }) async {
    final data = {
      'property_id': propertyId,
      'new_owner_name': newOwnerName,
      'new_owner_phone': newOwnerPhone,
      'transfer_type': transferType,
      'transfer_date': transferDate.toIso8601String(),
      'document_number': documentNumber,
      if (newOwnerEmail != null) 'new_owner_email': newOwnerEmail,
      if (newOwnerAddress != null) 'new_owner_address': newOwnerAddress,
      if (transferReason != null) 'transfer_reason': transferReason,
      if (comments != null) 'comments': comments,
    };

    final response = await _apiClient.post(
      ApiEndpoints.ownershipTransfer,
      data: data,
    );

    return OwnershipModel.fromJson(response.data);
  }

  // Get ownership history for a property
  Future<List<OwnershipModel>> getOwnershipHistory(String propertyId) async {
    final response = await _apiClient.get(
      ApiEndpoints.ownershipHistory,
      queryParameters: {'property_id': propertyId},
    );

    final data = response.data as List;
    return data
        .map((json) => OwnershipModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Update ownership record
  Future<OwnershipModel> updateOwnership(
    String id,
    OwnershipModel ownership,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.ownershipDetail(id),
      data: ownership.toJson(),
    );

    return OwnershipModel.fromJson(response.data);
  }

  // Delete ownership record
  Future<void> deleteOwnership(String id) async {
    await _apiClient.delete(ApiEndpoints.ownershipDetail(id));
  }
}
