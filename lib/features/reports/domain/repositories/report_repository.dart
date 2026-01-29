import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';

abstract class ReportRepository {
  Future<List<ReportModel>> getReports({
    int page,
    int pageSize,
    ReportType? type,
    ReportStatus? status,
    bool refresh,
  });

  Future<ReportModel> generateReport({
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    DateRange? dateRange,
    String? title,
  });

  Future<ReportModel> getReportDetail(String reportId);

  Future<void> downloadReport(String reportId);

  Future<void> deleteReport(String reportId);

  Future<ReportData> getDashboardStats({
    DateTime? startDate,
    DateTime? endDate,
    String? ward,
    String? zone,
  });

  Future<List<ReportType>> getAvailableReportTypes();

  Future<Map<String, dynamic>> getReportPreview({
    required ReportType type,
    DateRange? dateRange,
    Map<String, dynamic>? filters,
  });

  Future<ReportModel> cloneReport(String reportId);

  Future<void> exportReport(String reportId, ReportFormat format);

  Future<void> clearCache();
}
