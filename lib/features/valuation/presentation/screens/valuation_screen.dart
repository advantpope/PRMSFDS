import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/utils/form_validators.dart';

class ValuationScreen extends ConsumerStatefulWidget {
  const ValuationScreen({
    super.key,
    required this.propertyId,
    required this.currentValuation,
  });
  final String propertyId;
  final double currentValuation;

  @override
  ConsumerState<ValuationScreen> createState() => _ValuationScreenState();
}

class _ValuationScreenState extends ConsumerState<ValuationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _marketValueController = TextEditingController();
  final _assessedValueController = TextEditingController();
  final _valuationMethodController = TextEditingController();
  final _valuationOfficerController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedMethod = 'COMPARABLE_SALES';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _marketValueController.text = widget.currentValuation.toString();
    _assessedValueController.text = (widget.currentValuation * 0.8)
        .toStringAsFixed(2);
  }

  @override
  void dispose() {
    _marketValueController.dispose();
    _assessedValueController.dispose();
    _valuationMethodController.dispose();
    _valuationOfficerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitValuation() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Valuation submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  void _calculateAssessedValue() {
    final marketValue = double.tryParse(_marketValueController.text);
    if (marketValue != null) {
      _assessedValueController.text = (marketValue * 0.8).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'New Valuation', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Property Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Property ID: ${widget.propertyId}'),
                      const SizedBox(height: 8),
                      Text('Current Valuation: \$${widget.currentValuation}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Market Value
              const Text(
                'Market Value',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _marketValueController,
                decoration: const InputDecoration(
                  labelText: 'Market Value (\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  hintText: 'Enter market value',
                ),
                keyboardType: TextInputType.number,
                validator: FormValidators.positiveNumber,
                onChanged: (value) => _calculateAssessedValue(),
              ),
              const SizedBox(height: 16),

              // Assessed Value
              const Text(
                'Assessed Value',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _assessedValueController,
                decoration: const InputDecoration(
                  labelText: 'Assessed Value (\$)',
                  prefixIcon: Icon(Icons.assessment),
                  border: OutlineInputBorder(),
                  hintText: 'Calculated as 80% of market value',
                ),
                keyboardType: TextInputType.number,
                validator: FormValidators.positiveNumber,
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Valuation Method
              const Text(
                'Valuation Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.abc),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'COMPARABLE_SALES',
                    child: Text('Comparable Sales'),
                  ),
                  DropdownMenuItem(
                    value: 'INCOME_APPROACH',
                    child: Text('Income Approach'),
                  ),
                  DropdownMenuItem(
                    value: 'COST_APPROACH',
                    child: Text('Cost Approach'),
                  ),
                  DropdownMenuItem(
                    value: 'MASS_APPRAISAL',
                    child: Text('Mass Appraisal'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedMethod = value!);
                },
              ),
              const SizedBox(height: 16),

              // Valuation Officer
              TextFormField(
                controller: _valuationOfficerController,
                decoration: const InputDecoration(
                  labelText: 'Valuation Officer',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Enter officer name',
                ),
                validator: FormValidators.required,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                  hintText: 'Additional notes about the valuation',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitValuation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('SUBMIT VALUATION'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
