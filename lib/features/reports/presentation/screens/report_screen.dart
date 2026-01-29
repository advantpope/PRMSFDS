import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/features/reports/presentation/providers/report_provider.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/widgets/loading_indicator.dart';
import 'package:property_tax_system_fd/shared/widgets/error_widget.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reports', showBackButton: false),
      body: reportsAsync.isLoading
          ? const LoadingIndicator(message: 'Loading reports...')
          : reportsAsync.hasError
          ? ErrorWidget(message: reportsAsync.error!)
          : _buildReportList(reportsAsync.reports, ref),
      //  reportsAsync.isLoading(
      //   data: (reports) => _buildReportList(reports, ref),
      //   loading: () => const LoadingIndicator(message: 'Loading reports...'),
      //   error: (error, stackTrace) => ErrorWidget(message: error.toString()),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGenerateReportDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReportList(List<ReportModel> reports, WidgetRef ref) {
    if (reports.isEmpty) {
      return const Center(child: Text('No reports generated yet.'));
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return ListTile(
          leading: const Icon(Icons.description),
          title: Text(report.title),
          subtitle: Text('Type: ${report.type} - Status: ${report.status}'),
          trailing: report.status == 'completed' && report.fileUrl != null
              ? IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    ref.read(reportProvider.notifier).downloadReport(report.id);
                  },
                )
              : null,
          onTap: () {
            // Show report details or download
          },
        );
      },
    );
  }

  void _showGenerateReportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        dynamic selectedType = 'property';
        dynamic selectedFormat = 'pdf';
        final Map<String, dynamic> parameters = {};

        return AlertDialog(
          title: const Text('Generate Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(
                    value: 'property',
                    child: Text('Property Report'),
                  ),
                  DropdownMenuItem(value: 'tax', child: Text('Tax Report')),
                  DropdownMenuItem(
                    value: 'valuation',
                    child: Text('Valuation Report'),
                  ),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
                decoration: const InputDecoration(labelText: 'Report Type'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedFormat,
                items: const [
                  DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                  DropdownMenuItem(value: 'excel', child: Text('Excel')),
                ],
                onChanged: (value) {
                  selectedFormat = value!;
                },
                decoration: const InputDecoration(labelText: 'Format'),
              ),
              // Here you can add more fields for parameters based on the report type
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref
                      .read(reportProvider.notifier)
                      .generateReport(
                        type: selectedType,
                        format: selectedFormat,
                        parameters: parameters,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report generated successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to generate report: $e')),
                  );
                }
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }
}
