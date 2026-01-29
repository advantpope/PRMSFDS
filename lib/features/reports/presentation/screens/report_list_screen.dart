import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/features/reports/presentation/providers/report_provider.dart';
import 'package:property_tax_system_fd/features/reports/presentation/screens/report_generation_screen.dart';
import 'package:property_tax_system_fd/features/reports/presentation/widgets/report_card.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/widgets/loading_indicator.dart';
import 'package:property_tax_system_fd/shared/widgets/error_widget.dart';

class ReportListScreen extends ConsumerStatefulWidget {
  const ReportListScreen({super.key});

  @override
  ConsumerState<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends ConsumerState<ReportListScreen> {
  final _scrollController = ScrollController();
  ReportType? _selectedType;
  ReportStatus? _selectedStatus;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(reportProvider.notifier).loadMoreReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(reportProvider.notifier).refreshReports();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          if (_showFilters) _buildFilterBar(),

          // Reports List
          Expanded(child: _buildReportList(reportState)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReportGenerationScreen(initialType: _selectedType),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Type Filter
          Expanded(
            child: DropdownButtonFormField<ReportType?>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Types')),
                ...ReportType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type.name
                          .split('_')
                          .map(
                            (word) =>
                                '${word[0].toUpperCase()}${word.substring(1)}',
                          )
                          .join(' '),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value);
                ref.read(reportProvider.notifier).filterByType(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          // Status Filter
          Expanded(
            child: DropdownButtonFormField<ReportStatus?>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Status')),
                ...ReportStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.name[0].toUpperCase() + status.name.substring(1),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
                ref.read(reportProvider.notifier).filterByStatus(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList(ReportState reportState) {
    if (reportState.isLoading && reportState.reports.isEmpty) {
      return const LoadingIndicator(message: 'Loading reports...');
    }

    if (reportState.hasError && reportState.reports.isEmpty) {
      return ErrorWidget(
        message: reportState.error!,
        showRetry: true,
        onRetry: () {
          ref.read(reportProvider.notifier).refreshReports();
        },
      );
    }

    if (reportState.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Reports Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Generate your first report by tapping the + button',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(reportProvider.notifier).refreshReports();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: reportState.reports.length + (reportState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == reportState.reports.length) {
            return reportState.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox();
          }

          final report = reportState.reports[index];
          return ReportCard(
            report: report,
            onDownload: () {
              _downloadReport(report.id);
            },
            onDelete: () {
              _deleteReport(report.id);
            },
            onClone: () {
              _cloneReport(report.id);
            },
          );
        },
      ),
    );
  }

  Future<void> _downloadReport(String reportId) async {
    try {
      await ref.read(reportProvider.notifier).downloadReport(reportId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report downloaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteReport(String reportId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(reportProvider.notifier).deleteReport(reportId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cloneReport(String reportId) async {
    try {
      await ref.read(reportProvider.notifier).cloneReport(reportId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report cloned successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clone report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
