import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/auth/presentation/providers/auth_provider.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Mock data for dashboard
    final stats = {
      'total_properties': 156,
      'total_valuation': 25000000,
      'total_tax_collected': 1200000,
      'tax_due': 150000,
      'pending_valuations': 12,
      'active_users': 24,
    };

    final recentActivities = [
      {
        'type': 'property_added',
        'description': 'New property added: PT202400123',
        'time': '2 hours ago',
        'icon': Icons.add_home,
        'color': Colors.blue,
      },
      {
        'type': 'tax_paid',
        'description': 'Tax payment received: \$7,500',
        'time': '5 hours ago',
        'icon': Icons.payment,
        'color': Colors.green,
      },
      {
        'type': 'valuation_completed',
        'description': 'Valuation completed for PT202400045',
        'time': '1 day ago',
        'icon': Icons.assessment,
        'color': Colors.orange,
      },
      {
        'type': 'ownership_transferred',
        'description': 'Ownership transferred for PT202300789',
        'time': '2 days ago',
        'icon': Icons.swap_horiz,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Welcome back, ${user?.firstName ?? 'User'}!',
                          //   style: const TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // const SizedBox(height: 4),
                          // Text(
                          //   user?.isAdmin ?? false
                          //       ? 'Administrator Dashboard'
                          //       : 'Staff Dashboard',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          Text(
                            'Today: ${Formatters.formatDate(DateTime.now())}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            const Text(
              'Quick Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  title: 'Total Properties',
                  value: stats['total_properties'].toString(),
                  icon: Icons.apartment,
                  color: Colors.blue,
                  prefix: '',
                ),
                _buildStatCard(
                  title: 'Total Valuation',
                  value: Formatters.formatCurrency(
                    stats['total_valuation']!.toDouble(),
                  ),
                  icon: Icons.assessment,
                  color: Colors.green,
                  prefix: '\$',
                ),
                _buildStatCard(
                  title: 'Tax Collected',
                  value: Formatters.formatCurrency(
                    stats['total_tax_collected']!.toDouble(),
                  ),
                  icon: Icons.attach_money,
                  color: Colors.orange,
                  prefix: '\$',
                ),
                _buildStatCard(
                  title: 'Tax Due',
                  value: Formatters.formatCurrency(
                    stats['tax_due']!.toDouble(),
                  ),
                  icon: Icons.warning,
                  color: Colors.red,
                  prefix: '\$',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activities
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: recentActivities.map((activity) {
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: activity['color'] as Color? ?? Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          activity['icon'] as IconData? ?? Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(activity['description'] as String),
                      subtitle: Text(activity['time'] as String),
                      trailing: const Icon(Icons.chevron_right),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickActionButton(
                  icon: Icons.add_home,
                  label: 'Add Property',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/add-property');
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.assessment,
                  label: 'New Valuation',
                  color: Colors.green,
                  onTap: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.receipt,
                  label: 'Generate Bill',
                  color: Colors.orange,
                  onTap: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.bar_chart,
                  label: 'View Reports',
                  color: Colors.purple,
                  onTap: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.search,
                  label: 'Search Property',
                  color: Colors.red,
                  onTap: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.print,
                  label: 'Print Reports',
                  color: Colors.teal,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String prefix,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$prefix$value',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
