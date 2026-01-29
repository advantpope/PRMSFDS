import 'package:dio/dio.dart';
import 'package:property_tax_system_fd/core/network/api_client.dart';
import 'package:property_tax_system_fd/core/config/api_endpoints.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/core/network/api_response.dart';

class ReportApi {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<ReportModel>> getReports({
    int page = 1,
    int pageSize = 20,
    ReportType? type,
    ReportStatus? status,
  }) async {
    final queryParams = {
      'page': page,
      'page_size': pageSize,
      if (type != null) 'type': type.name,
      if (status != null) 'status': status.name,
    };

    final response = await _apiClient.get(
      ApiEndpoints.reports,
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => ReportModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ReportModel> generateReport({
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    DateRange? dateRange,
    String? title,
  }) async {
    final data = {
      'type': type.name,
      'format': format.name,
      'parameters': parameters,
      if (dateRange != null) 'date_range': dateRange.toJson(),
      if (title != null && title.isNotEmpty) 'title': title,
    };

    final response = await _apiClient.post(
      ApiEndpoints.generateReport,
      data: data,
    );

    return ReportModel.fromJson(response.data);
  }

  Future<ReportModel> getReportDetail(String reportId) async {
    final response = await _apiClient.get('${ApiEndpoints.reports}$reportId/');
    return ReportModel.fromJson(response.data);
  }

  Future<void> downloadReport(String reportId, String savePath) async {
    await _apiClient.download(
      '${ApiEndpoints.reports}$reportId/download/',
      savePath,
    );
  }

  Future<void> deleteReport(String reportId) async {
    await _apiClient.delete('${ApiEndpoints.reports}$reportId/');
  }

  Future<ReportData> getDashboardStats({
    DateTime? startDate,
    DateTime? endDate,
    String? ward,
    String? zone,
  }) async {
    final queryParams = {
      if (startDate != null) 'start_date': startDate.toIso8601String(),
      if (endDate != null) 'end_date': endDate.toIso8601String(),
      if (ward != null) 'ward': ward,
      if (zone != null) 'zone': zone,
    };

    final response = await _apiClient.get(
      ApiEndpoints.dashboardStats,
      queryParameters: queryParams,
    );

    return ReportData.fromJson(response.data);
  }

  Future<List<ReportType>> getAvailableReportTypes() async {
    final response = await _apiClient.get('${ApiEndpoints.reports}types/');
    final data = response.data as List;
    return data
        .map(
          (type) =>
              ReportType.values.firstWhere((e) => e.name == (type as String)),
        )
        .toList();
  }

  Future<Map<String, dynamic>> getReportPreview({
    required ReportType type,
    DateRange? dateRange,
    Map<String, dynamic>? filters,
  }) async {
    final data = {
      'type': type.name,
      if (dateRange != null) 'date_range': dateRange.toJson(),
      if (filters != null) 'filters': filters,
    };

    final response = await _apiClient.post(
      '${ApiEndpoints.reports}preview/',
      data: data,
    );

    return response.data;
  }

  Future<ReportModel> cloneReport(String reportId) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.reports}$reportId/clone/',
    );
    return ReportModel.fromJson(response.data);
  }

  Future<void> exportReport(String reportId, ReportFormat format) async {
    await _apiClient.post(
      '${ApiEndpoints.reports}$reportId/export/',
      data: {'format': format.name},
    );
  }
}
