import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;
  final VoidCallback? onClone;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.report,
    this.onDownload,
    this.onDelete,
    this.onClone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(report.status),
                ],
              ),
              const SizedBox(height: 8),

              // Report Type and Format
              Row(
                children: [
                  _buildDetailItem(
                    icon: Icons.assessment,
                    label: report.type.name
                        .split('_')
                        .map(
                          (word) =>
                              '${word[0].toUpperCase()}${word.substring(1)}',
                        )
                        .join(' '),
                  ),
                  const SizedBox(width: 16),
                  _buildDetailItem(
                    icon: Icons.format_align_left,
                    label: report.format.name.toUpperCase(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date Range if available
              if (report.dateRange != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        report.dateRange!.formattedRange,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              // File Info and Created Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (report.fileUrl != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          report.fileSizeFormatted,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.download,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${report.downloadCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Text(
                    'Created: ${DateFormat('MMM dd, yyyy').format(report.createdAt)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action Buttons
              if (report.isCompleted) _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case ReportStatus.completed:
        chipColor = Colors.green;
        statusText = 'COMPLETED';
        break;
      case ReportStatus.processing:
        chipColor = Colors.blue;
        statusText = 'PROCESSING';
        break;
      case ReportStatus.pending:
        chipColor = Colors.orange;
        statusText = 'PENDING';
        break;
      case ReportStatus.failed:
        chipColor = Colors.red;
        statusText = 'FAILED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.download,
          label: 'Download',
          color: Colors.blue,
          onPressed: onDownload,
        ),
        _buildActionButton(
          icon: Icons.content_copy,
          label: 'Clone',
          color: Colors.purple,
          onPressed: onClone,
        ),
        _buildActionButton(
          icon: Icons.share,
          label: 'Share',
          color: Colors.green,
          onPressed: () {
            _shareReport(context);
          },
        ),
        _buildActionButton(
          icon: Icons.delete,
          label: 'Delete',
          color: Colors.red,
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 20),
          color: color,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onPressed,
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }

  void _shareReport(BuildContext context) {
    final shareText =
        '''
Report: ${report.title}
Type: ${report.type.name}
Format: ${report.format.name}
Created: ${DateFormat('yyyy-MM-dd').format(report.createdAt)}
Status: ${report.status.name}
---
Shared from Property Tax System
''';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share Report'),
          content: SelectableText(shareText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report details copied to clipboard'),
                  ),
                );
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }
}
