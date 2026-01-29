import 'package:hive/hive.dart';
import 'package:property_tax_system_fd/features/reports/data/datasources/report_api.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/features/reports/domain/repositories/report_repository.dart';
import 'package:property_tax_system_fd/shared/services/storage_service.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    required ReportApi reportApi,
    required Box<ReportModel> reportBox,
    required StorageService storageService,
  }) : _reportApi = reportApi,
       _reportBox = reportBox,
       _storageService = storageService;
  final ReportApi _reportApi;
  final Box<ReportModel> _reportBox;
  final StorageService _storageService;

  @override
  Future<List<ReportModel>> getReports({
    int page = 1,
    int pageSize = 20,
    ReportType? type,
    ReportStatus? status,
    bool refresh = false,
  }) async {
    if (!refresh) {
      final cachedReports = _getCachedReports(type, status);
      if (cachedReports.isNotEmpty) {
        return cachedReports;
      }
    }

    try {
      final response = await _reportApi.getReports(
        page: page,
        pageSize: pageSize,
        type: type,
        status: status,
      );

      await _cacheReports(response.results);
      return response.results;
    } catch (e) {
      final cachedReports = _getCachedReports(type, status);
      if (cachedReports.isNotEmpty) {
        return cachedReports;
      }
      rethrow;
    }
  }

  @override
  Future<ReportModel> generateReport({
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    DateRange? dateRange,
    String? title,
  }) async {
    final report = await _reportApi.generateReport(
      type: type,
      format: format,
      parameters: parameters,
      dateRange: dateRange,
      title: title,
    );

    await _reportBox.put(report.id, report);
    return report;
  }

  @override
  Future<ReportModel> getReportDetail(String reportId) async {
    final cachedReport = _reportBox.get(reportId);
    if (cachedReport != null) {
      return cachedReport;
    }

    final report = await _reportApi.getReportDetail(reportId);
    await _reportBox.put(reportId, report);
    return report;
  }

  @override
  Future<void> downloadReport(String reportId) async {
    final report = await getReportDetail(reportId);
    if (report.fileUrl == null) {
      throw Exception('Report not ready for download');
    }

    final fileName =
        '${report.title}_${DateTime.now().millisecondsSinceEpoch}.${report.format.name}';
    final savePath = await _storageService.getReportFilePath(fileName);

    await _reportApi.downloadReport(reportId, savePath);

    // Update download count in cache
    final updatedReport = report.copyWith(
      downloadCount: report.downloadCount + 1,
    );
    await _reportBox.put(reportId, updatedReport);
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _reportApi.deleteReport(reportId);
    await _reportBox.delete(reportId);
  }

  @override
  Future<ReportData> getDashboardStats({
    DateTime? startDate,
    DateTime? endDate,
    String? ward,
    String? zone,
  }) async {
    final cacheKey = _generateStatsCacheKey(startDate, endDate, ward, zone);
    final cachedStats = await _storageService.getObject(cacheKey);

    if (cachedStats != null) {
      return ReportData.fromJson(cachedStats);
    }

    final stats = await _reportApi.getDashboardStats(
      startDate: startDate,
      endDate: endDate,
      ward: ward,
      zone: zone,
    );

    await _storageService.saveObject(cacheKey, stats.toJson());
    return stats;
  }

  @override
  Future<List<ReportType>> getAvailableReportTypes() async {
    try {
      return await _reportApi.getAvailableReportTypes();
    } catch (e) {
      // Return default report types if API fails
      return ReportType.values;
    }
  }

  @override
  Future<Map<String, dynamic>> getReportPreview({
    required ReportType type,
    DateRange? dateRange,
    Map<String, dynamic>? filters,
  }) async {
    return await _reportApi.getReportPreview(
      type: type,
      dateRange: dateRange,
      filters: filters,
    );
  }

  @override
  Future<ReportModel> cloneReport(String reportId) async {
    final report = await getReportDetail(reportId);
    final clonedReport = await _reportApi.cloneReport(reportId);
    await _reportBox.put(clonedReport.id, clonedReport);
    return clonedReport;
  }

  @override
  Future<void> exportReport(String reportId, ReportFormat format) async {
    await _reportApi.exportReport(reportId, format);
  }

  // Helper methods
  List<ReportModel> _getCachedReports(ReportType? type, ReportStatus? status) {
    var reports = _reportBox.values.toList();

    if (type != null) {
      reports = reports.where((r) => r.type == type).toList();
    }

    if (status != null) {
      reports = reports.where((r) => r.status == status).toList();
    }

    return reports;
  }

  Future<void> _cacheReports(List<ReportModel> reports) async {
    for (final report in reports) {
      await _reportBox.put(report.id, report);
    }
  }

  String _generateStatsCacheKey(
    DateTime? startDate,
    DateTime? endDate,
    String? ward,
    String? zone,
  ) {
    final parts = [
      'dashboard_stats',
      startDate?.toIso8601String() ?? 'all',
      endDate?.toIso8601String() ?? 'all',
      ward ?? 'all',
      zone ?? 'all',
    ];
    return parts.join('_');
  }

  @override
  Future<void> clearCache() async {
    await _reportBox.clear();
  }
}

// Extension for copyWith method on ReportModel
extension ReportModelCopyWith on ReportModel {
  ReportModel copyWith({
    String? id,
    String? title,
    ReportType? type,
    ReportFormat? format,
    ReportStatus? status,
    DateRange? dateRange,
    Map<String, dynamic>? parameters,
    String? fileUrl,
    int? fileSize,
    DateTime? createdAt,
    DateTime? completedAt,
    int? downloadCount,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      format: format ?? this.format,
      status: status ?? this.status,
      dateRange: dateRange ?? this.dateRange,
      parameters: parameters ?? this.parameters,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      downloadCount: downloadCount ?? this.downloadCount,
    );
  }
}
