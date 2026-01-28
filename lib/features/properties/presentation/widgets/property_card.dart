import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_detail_screen.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_detail_screen.dart';

class PropertyCard extends ConsumerWidget {
  final PropertyModel property;
  final VoidCallback? onTap;
  final bool showActions;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap:
            onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailScreen(
                    propertyId: property.id.toString(),
                    initialProperty: property,
                  ),
                ),
              );
            },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Property ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      property.propertyId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 8),

              // Address
              Text(
                property.address,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Property Details Row
              Row(
                children: [
                  _buildDetailItem(
                    icon: Icons.category,
                    value: property.propertyType,
                  ),
                  const SizedBox(width: 16),
                  _buildDetailItem(
                    icon: Icons.square_foot,
                    value: '${Formatters.formatArea(property.areaSqft)} sq ft',
                  ),
                  const SizedBox(width: 16),
                  _buildDetailItem(icon: Icons.apartment, value: property.ward),
                ],
              ),
              const SizedBox(height: 12),

              // Valuation and Tax Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valuation',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        property.currentValuation != null
                            ? '\$${Formatters.formatCurrency(property.currentValuation!)}'
                            : 'Not valued',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Annual Tax',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '\$${Formatters.formatCurrency(property.annualTax ?? 0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Owner Information (if available)
              if (property.currentOwner != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      property.currentOwner!.ownerName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Owner',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              // Actions Row
              if (showActions) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    if (!property.isActive) {
      chipColor = Colors.red;
      statusText = 'INACTIVE';
    } else if (property.annualTax != null && property.annualTax! > 0) {
      chipColor = Colors.green;
      statusText = 'ACTIVE';
    } else {
      chipColor = Colors.orange;
      statusText = 'PENDING';
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

  Widget _buildDetailItem({required IconData icon, required String value}) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _formatPropertyType(value),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPropertyType(String value) {
    // Convert ENUM values to readable format
    return value
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.remove_red_eye,
          label: 'View',
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailScreen(
                  propertyId: property.id.toString(),
                  initialProperty: property,
                ),
              ),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.receipt,
          label: 'Tax',
          color: Colors.green,
          onPressed: () {
            _showTaxDetails(context);
          },
        ),
        _buildActionButton(
          icon: Icons.assessment,
          label: 'Value',
          color: Colors.orange,
          onPressed: () {
            _showValuationDetails(context);
          },
        ),
        _buildActionButton(
          icon: Icons.location_on,
          label: 'Map',
          color: Colors.purple,
          onPressed: () {
            _showOnMap(context);
          },
        ),
        _buildActionButton(
          icon: Icons.share,
          label: 'Share',
          color: Colors.grey,
          onPressed: () {
            _shareProperty(context);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
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

  void _showTaxDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tax Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTaxDetailRow(
                'Annual Tax',
                '\$${Formatters.formatCurrency(property.annualTax ?? 0)}',
                Colors.red,
              ),
              _buildTaxDetailRow(
                'Last Payment',
                property.updatedAt != null
                    ? Formatters.formatDate(property.updatedAt!)
                    : 'N/A',
                Colors.blue,
              ),
              _buildTaxDetailRow(
                'Payment Status',
                property.annualTax != null && property.annualTax! > 0
                    ? 'Pending'
                    : 'Paid',
                property.annualTax != null && property.annualTax! > 0
                    ? Colors.orange
                    : Colors.green,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _makePayment(context);
                      },
                      child: const Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaxDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _showValuationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Valuation Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.assessment, color: Colors.blue),
                title: const Text('Current Valuation'),
                subtitle: Text(
                  property.currentValuation != null
                      ? '\$${Formatters.formatCurrency(property.currentValuation!)}'
                      : 'Not valued',
                ),
                trailing: property.currentValuation != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.error, color: Colors.orange),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: const Text('Last Valuation'),
                subtitle: Text(
                  property.updatedAt != null
                      ? Formatters.formatDate(property.updatedAt!)
                      : 'N/A',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.apartment, color: Colors.blue),
                title: const Text('Property Type'),
                subtitle: Text(_formatPropertyType(property.propertyType)),
              ),
              ListTile(
                leading: const Icon(Icons.square_foot, color: Colors.blue),
                title: const Text('Area'),
                subtitle: Text('${property.areaSqft} sq ft'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _requestNewValuation(context);
                      },
                      child: const Text('New Valuation'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOnMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Property Location'),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(property.address, textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(
                          'Lat: ${property.latitude.toStringAsFixed(6)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Lng: ${property.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.apartment, size: 16),
                    const SizedBox(width: 8),
                    Text('Ward: ${property.ward}'),
                    const Spacer(),
                    const Icon(Icons.map, size: 16),
                    const SizedBox(width: 8),
                    Text('Zone: ${property.zone}'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _openInMaps();
              },
              child: const Text('Open in Maps'),
            ),
          ],
        );
      },
    );
  }

  void _shareProperty(BuildContext context) {
    final shareText =
        '''
Property: ${property.propertyId}
Address: ${property.address}
Ward: ${property.ward}, Zone: ${property.zone}
Valuation: \$${Formatters.formatCurrency(property.currentValuation ?? 0)}
Annual Tax: \$${Formatters.formatCurrency(property.annualTax ?? 0)}
---
Shared from Property Tax System
''';

    // In a real app, you would use a share plugin
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share Property'),
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
                    content: Text('Property details copied to clipboard'),
                  ),
                );
                // You would implement actual sharing here
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }

  void _makePayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Make Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'Amount: \$${Formatters.formatCurrency(property.annualTax ?? 0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Property Tax Payment'),
              const SizedBox(height: 16),
              const Text('Select payment method:'),
              const SizedBox(height: 8),
              const Wrap(
                spacing: 8,
                children: const [
                  Chip(label: Text('Credit Card')),
                  Chip(label: Text('Bank Transfer')),
                  Chip(label: Text('Mobile Money')),
                ],
              ),
            ],
          ),
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
                    content: Text('Payment processing...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Pay Now'),
            ),
          ],
        );
      },
    );
  }

  void _requestNewValuation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Valuation Request'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assessment, size: 48, color: Colors.orange),
              SizedBox(height: 16),
              Text('Request a new valuation for this property?'),
              SizedBox(height: 8),
              Text(
                'A valuation officer will visit the property and provide an updated valuation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
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
                    content: Text('Valuation request submitted'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Request'),
            ),
          ],
        );
      },
    );
  }

  void _openInMaps() {
    // In a real app, you would use a maps plugin to open the location
    final mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${property.latitude},${property.longitude}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening in maps...'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // You would launch the URL here
          },
        ),
      ),
    );
  }
}
