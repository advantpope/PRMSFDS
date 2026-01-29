import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:property_tax_system_fd/features/reports/data/models/report_model.dart';
import 'package:property_tax_system_fd/features/reports/presentation/providers/report_provider.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/widgets/loading_indicator.dart';
import 'package:property_tax_system_fd/shared/widgets/error_dialog.dart';
import 'package:property_tax_system_fd/shared/utils/form_validators.dart';

class ReportGenerationScreen extends ConsumerStatefulWidget {
  final ReportType? initialType;

  const ReportGenerationScreen({super.key, this.initialType});

  @override
  ConsumerState<ReportGenerationScreen> createState() =>
      _ReportGenerationScreenState();
}

class _ReportGenerationScreenState
    extends ConsumerState<ReportGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  ReportType _selectedType = ReportType.propertyList;
  ReportFormat _selectedFormat = ReportFormat.pdf;
  DateTime? _startDate;
  DateTime? _endDate;
  Map<String, dynamic> _parameters = {};
  bool _isGenerating = false;

  final Map<ReportType, String> _reportDescriptions = {
    ReportType.propertyList: 'Complete list of all properties with details',
    ReportType.taxCollection: 'Summary of tax collection for selected period',
    ReportType.valuation: 'Property valuation report',
    ReportType.ownership: 'Ownership transfer history',
    ReportType.taxDue: 'List of properties with pending tax payments',
    ReportType.paymentReceipts: 'Payment receipts for selected period',
    ReportType.clearanceCertificates: 'Tax clearance certificates',
    ReportType.wardWise: 'Ward-wise property distribution',
    ReportType.zoneWise: 'Zone-wise analysis report',
    ReportType.annualSummary: 'Annual summary report',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
    _updateParametersForType();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateParametersForType() {
    _parameters = {};
    _titleController.text = _getDefaultTitle();

    switch (_selectedType) {
      case ReportType.propertyList:
        _parameters = {
          'include_inactive': false,
          'include_images': false,
          'sort_by': 'property_id',
          'include_owner_details': true,
          'include_tax_status': true,
        };
        break;
      case ReportType.taxCollection:
        _parameters = {
          'group_by': 'month',
          'include_details': true,
          'show_comparison': true,
        };
        break;
      case ReportType.taxDue:
        _parameters = {
          'show_overdue_only': true,
          'include_contact_info': true,
          'sort_by': 'amount_due',
        };
        break;
      case ReportType.wardWise:
        _parameters = {
          'compare_with_previous': true,
          'include_charts': true,
          'detailed_breakdown': true,
        };
        break;
      default:
        _parameters = {'detailed': true};
    }
  }

  String _getDefaultTitle() {
    final typeName = _selectedType.name
        .split('_')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return '$typeName Report - $date';
  }

  Future<void> _pickStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() => _startDate = pickedDate);
    }
  }

  Future<void> _pickEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() => _endDate = pickedDate);
    }
  }

  Future<void> _generateReport() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == ReportType.taxCollection &&
          (_startDate == null || _endDate == null)) {
        _showError('Please select date range for tax collection report');
        return;
      }

      setState(() => _isGenerating = true);

      try {
        DateRange? dateRange;
        if (_startDate != null && _endDate != null) {
          dateRange = DateRange(startDate: _startDate!, endDate: _endDate!);
        }

        final report = await ref
            .read(reportProvider.notifier)
            .generateReport(
              type: _selectedType,
              format: _selectedFormat,
              parameters: _parameters,
              dateRange: dateRange,
              title: _titleController.text.trim(),
            );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report "${report.title}" generated successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                // Navigate to report detail
              },
            ),
          ),
        );

        // Navigate back after delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      } catch (e) {
        _showError('Failed to generate report: $e');
      } finally {
        if (mounted) {
          setState(() => _isGenerating = false);
        }
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(title: 'Error', message: message),
    );
  }

  Widget _buildParameterField(String key, dynamic value) {
    if (value is bool) {
      return CheckboxListTile(
        title: Text(key.replaceAll('_', ' ').toUpperCase()),
        value: value,
        onChanged: (newValue) {
          setState(() {
            _parameters[key] = newValue;
          });
        },
      );
    }

    if (value is String) {
      return TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: key.replaceAll('_', ' ').toUpperCase(),
        ),
        onChanged: (newValue) {
          _parameters[key] = newValue;
        },
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Generate Report',
        showBackButton: true,
      ),
      body: _isGenerating
          ? const LoadingIndicator(message: 'Generating report...')
          : _buildFormContent(),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Report Title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: FormValidators.required,
            ),
            const SizedBox(height: 16),

            // Report Type
            _buildSectionTitle('Report Type'),
            DropdownButtonFormField<ReportType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Select Report Type',
                prefixIcon: Icon(Icons.assessment),
              ),
              items: ReportType.values.map((type) {
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
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                    _updateParametersForType();
                  });
                }
              },
              validator: (value) =>
                  value == null ? 'Please select report type' : null,
            ),
            const SizedBox(height: 8),

            // Report Description
            Text(
              _reportDescriptions[_selectedType] ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Output Format
            _buildSectionTitle('Output Format'),
            Wrap(
              spacing: 8,
              children: ReportFormat.values.map((format) {
                return ChoiceChip(
                  label: Text(format.name.toUpperCase()),
                  selected: _selectedFormat == format,
                  onSelected: (selected) {
                    setState(() => _selectedFormat = format);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Date Range (for certain report types)
            if (_selectedType == ReportType.taxCollection ||
                _selectedType == ReportType.paymentReceipts ||
                _selectedType == ReportType.annualSummary)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Date Range'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _startDate != null
                                ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                : 'Select Start Date',
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickStartDate,
                          validator: (value) {
                            if (_startDate == null) {
                              return 'Please select start date';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _endDate != null
                                ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                : 'Select End Date',
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickEndDate,
                          validator: (value) {
                            if (_endDate == null) {
                              return 'Please select end date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Report Parameters
            _buildSectionTitle('Report Parameters'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _parameters.entries.map((entry) {
                    return _buildParameterField(entry.key, entry.value);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.file_download),
                label: const Text('GENERATE REPORT'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
