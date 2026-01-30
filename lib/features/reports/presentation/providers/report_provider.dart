import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:property_tax_system_fd/core/config/app_constants.dart';
import 'package:property_tax_system_fd/features/auth/presentation/providers/auth_provider.dart';
import 'package:property_tax_system_fd/features/reports/data/datasources/report_api.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/features/reports/data/repositories/report_repository_impl.dart';
import 'package:property_tax_system_fd/features/reports/domain/repositories/report_repository.dart';
import 'package:property_tax_system_fd/shared/services/storage_service.dart';

// Providers
final reportApiProvider = Provider<ReportApi>((ref) {
  return ReportApi();
});

final reportBoxProvider = Provider<Box<ReportModel>>((ref) {
  return Hive.box<ReportModel>(AppConstants.reportsBox);
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(
    reportApi: ref.read(reportApiProvider),
    reportBox: ref.read(reportBoxProvider),
    storageService: ref.read(storageServiceProvider),
  );
});

// Main report provider
final reportProvider = StateNotifierProvider<ReportNotifier, ReportState>(
  (ref) => ReportNotifier(ref.read(reportRepositoryProvider)),
);

// Report detail provider
final reportDetailProvider = FutureProvider.family<ReportModel?, String>((
  ref,
  reportId,
) async {
  try {
    final repository = ref.read(reportRepositoryProvider);
    return await repository.getReportDetail(reportId);
  } catch (e) {
    return null;
  }
});

// Dashboard stats provider
final dashboardStatsProvider = FutureProvider<ReportData>((ref) async {
  final repository = ref.read(reportRepositoryProvider);
  return await repository.getDashboardStats();
});

// Available report types provider
final availableReportTypesProvider = FutureProvider<List<ReportType>>((
  ref,
) async {
  final repository = ref.read(reportRepositoryProvider);
  return await repository.getAvailableReportTypes();
});

// Report State
class ReportState {
  const ReportState({
    this.reports = const [],
    this.selectedType,
    this.selectedStatus,
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });
  final List<ReportModel> reports;
  final ReportType? selectedType;
  final ReportStatus? selectedStatus;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  ReportState copyWith({
    List<ReportModel>? reports,
    ReportType? selectedType,
    ReportStatus? selectedStatus,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return ReportState(
      reports: reports ?? this.reports,
      selectedType: selectedType ?? this.selectedType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => !isLoading && reports.isEmpty;
}

// Report Notifier
class ReportNotifier extends StateNotifier<ReportState> {
  final ReportRepository _repository;

  ReportNotifier(this._repository) : super(const ReportState()) {
    loadReports();
  }

  Future<void> loadReports({bool refresh = false}) async {
    if (!refresh && state.isLoading) return;

    final page = refresh ? 1 : state.currentPage;

    state = state.copyWith(isLoading: true, error: null, currentPage: page);

    try {
      final reports = await _repository.getReports(
        page: page,
        pageSize: 20,
        type: state.selectedType,
        status: state.selectedStatus,
        refresh: refresh,
      );

      final allReports = refresh ? reports : [...state.reports, ...reports];
      final hasMore = reports.length == 20; // Assuming 20 items per page

      state = state.copyWith(
        reports: allReports,
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load reports: $e',
      );
    }
  }

  Future<void> loadMoreReports() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(currentPage: state.currentPage + 1);

    await loadReports();
  }

  Future<ReportModel> generateReport({
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    DateRange? dateRange,
    String? title,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final report = await _repository.generateReport(
        type: type,
        format: format,
        parameters: parameters,
        dateRange: dateRange,
        title: title,
      );

      // Add new report to the beginning of the list
      final updatedReports = [report, ...state.reports];
      state = state.copyWith(reports: updatedReports, isLoading: false);

      return report;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate report: $e',
      );
      rethrow;
    }
  }

  Future<void> downloadReport(String reportId) async {
    try {
      await _repository.downloadReport(reportId);

      // Update the report in the list with new download count
      final index = state.reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        final report = state.reports[index];
        final updatedReport = report.copyWith(
          downloadCount: report.downloadCount + 1,
        );
        final updatedReports = List<ReportModel>.from(state.reports);
        updatedReports[index] = updatedReport;
        state = state.copyWith(reports: updatedReports);
      }
    } catch (e) {
      throw Exception('Failed to download report: $e');
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _repository.deleteReport(reportId);

      final updatedReports = state.reports
          .where((r) => r.id != reportId)
          .toList();
      state = state.copyWith(reports: updatedReports);
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  Future<ReportData> getDashboardStats({
    DateTime? startDate,
    DateTime? endDate,
    String? ward,
    String? zone,
  }) async {
    try {
      return await _repository.getDashboardStats(
        startDate: startDate,
        endDate: endDate,
        ward: ward,
        zone: zone,
      );
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }

  void filterByType(ReportType? type) {
    state = state.copyWith(
      selectedType: type,
      currentPage: 1,
      reports: [],
      hasMore: true,
    );
    loadReports(refresh: true);
  }

  void filterByStatus(ReportStatus? status) {
    state = state.copyWith(
      selectedStatus: status,
      currentPage: 1,
      reports: [],
      hasMore: true,
    );
    loadReports(refresh: true);
  }

  Future<ReportModel> cloneReport(String reportId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final report = await _repository.cloneReport(reportId);

      // Add cloned report to the beginning of the list
      final updatedReports = [report, ...state.reports];
      state = state.copyWith(reports: updatedReports, isLoading: false);

      return report;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to clone report: $e',
      );
      rethrow;
    }
  }

  Future<void> exportReport(String reportId, ReportFormat format) async {
    try {
      await _repository.exportReport(reportId, format);
    } catch (e) {
      throw Exception('Failed to export report: $e');
    }
  }

  Future<Map<String, dynamic>> getReportPreview({
    required ReportType type,
    DateRange? dateRange,
    Map<String, dynamic>? filters,
  }) async {
    try {
      return await _repository.getReportPreview(
        type: type,
        dateRange: dateRange,
        filters: filters,
      );
    } catch (e) {
      throw Exception('Failed to get report preview: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refreshReports() async {
    await loadReports(refresh: true);
  }
}
