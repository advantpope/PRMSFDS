import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';

class TaxDetailsScreen extends ConsumerStatefulWidget {
  final String propertyId;
  final double propertyTax;

  const TaxDetailsScreen({
    super.key,
    required this.propertyId,
    required this.propertyTax,
  });

  @override
  ConsumerState<TaxDetailsScreen> createState() => _TaxDetailsScreenState();
}

class _TaxDetailsScreenState extends ConsumerState<TaxDetailsScreen> {
  final List<Map<String, dynamic>> _taxHistory = [
    {
      'year': 2023,
      'amount': 7500.00,
      'paid': 7500.00,
      'status': 'PAID',
      'dueDate': '2023-12-31',
      'paymentDate': '2023-06-15',
      'receipt': 'RC20230615',
    },
    {
      'year': 2022,
      'amount': 7200.00,
      'paid': 7200.00,
      'status': 'PAID',
      'dueDate': '2022-12-31',
      'paymentDate': '2022-07-20',
      'receipt': 'RC20220720',
    },
    {
      'year': 2021,
      'amount': 6900.00,
      'paid': 6900.00,
      'status': 'PAID',
      'dueDate': '2021-12-31',
      'paymentDate': '2021-08-10',
      'receipt': 'RC20210810',
    },
  ];

  String _selectedYear = '2024';
  bool _isMakingPayment = false;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final totalTax = _taxHistory.fold(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );
    final totalPaid = _taxHistory.fold(
      0.0,
      (sum, item) => sum + (item['paid'] as double),
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Tax Details', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Tax Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          label: 'Current Year',
                          value: '${currentYear}',
                          color: Colors.blue,
                        ),
                        _buildStatCard(
                          label: 'Total Tax',
                          value: '\$${Formatters.formatCurrency(totalTax)}',
                          color: Colors.red,
                        ),
                        _buildStatCard(
                          label: 'Total Paid',
                          value: '\$${Formatters.formatCurrency(totalPaid)}',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Current Year Tax
            const Text(
              'Current Year Tax',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt, color: Colors.orange),
                title: const Text('2024 Property Tax'),
                subtitle: const Text('Due: December 31, 2024'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${Formatters.formatCurrency(widget.propertyTax)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      'PENDING',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Make Payment Section
            const Text(
              'Make Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedYear,
                            decoration: const InputDecoration(
                              labelText: 'Select Year',
                              border: OutlineInputBorder(),
                            ),
                            items: ['2024', '2023', '2022', '2021']
                                .map(
                                  (year) => DropdownMenuItem(
                                    value: year,
                                    child: Text(year),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedYear = value!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: Formatters.formatCurrency(
                              widget.propertyTax,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Amount (\$)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: 'CREDIT_CARD',
                      decoration: const InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'CREDIT_CARD',
                          child: Text('Credit Card'),
                        ),
                        DropdownMenuItem(
                          value: 'BANK_TRANSFER',
                          child: Text('Bank Transfer'),
                        ),
                        DropdownMenuItem(
                          value: 'MOBILE_MONEY',
                          child: Text('Mobile Money'),
                        ),
                        DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isMakingPayment
                            ? null
                            : () {
                                setState(() => _isMakingPayment = true);
                                Future.delayed(
                                  const Duration(seconds: 2),
                                ).then((_) {
                                  if (mounted) {
                                    setState(() => _isMakingPayment = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Payment processed successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                });
                              },
                        icon: const Icon(Icons.payment),
                        label: _isMakingPayment
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('MAKE PAYMENT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tax History
            const Text(
              'Tax History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._taxHistory.map((tax) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    tax['status'] == 'PAID'
                        ? Icons.check_circle
                        : Icons.pending,
                    color: tax['status'] == 'PAID'
                        ? Colors.green
                        : Colors.orange,
                  ),
                  title: Text('Property Tax ${tax['year']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due: ${tax['dueDate']}'),
                      if (tax['paymentDate'] != null)
                        Text('Paid: ${tax['paymentDate']}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${Formatters.formatCurrency(tax['amount'] as double)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tax['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: tax['status'] == 'PAID'
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(Icons.attach_money, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
