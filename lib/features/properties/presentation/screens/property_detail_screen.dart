import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_tax_system_fd/features/properties/presentation/providers/property_provider.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/add_edit_property_screen.dart';
import 'package:property_tax_system_fd/features/ownership/presentation/screens/ownership_transfer_screen.dart';
import 'package:property_tax_system_fd/features/valuation/presentation/screens/valuation_screen.dart';
import 'package:property_tax_system_fd/features/taxation/presentation/screens/tax_details_screen.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/widgets/loading_indicator.dart';
import 'package:property_tax_system_fd/shared/widgets/error_widget.dart';
import 'package:property_tax_system_fd/shared/widgets/image_viewer.dart';
import 'package:property_tax_system_fd/shared/widgets/property_map_preview.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;
  final PropertyModel? initialProperty;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;
  PropertyModel? _property;
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Overview',
    'Valuation',
    'Taxation',
    'Ownership',
    'Documents',
  ];

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProperty() async {
    if (widget.initialProperty != null) {
      setState(() {
        _property = widget.initialProperty;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      // In a real app, you would fetch from your provider
      // For now, we'll simulate loading
      await Future.delayed(const Duration(milliseconds: 500));

      // This would come from your provider
      // final property = await ref.read(propertyProvider.notifier).getPropertyById(widget.propertyId);

      // Mock data for demonstration
      final mockProperty = PropertyModel(
        id: int.parse(widget.propertyId),
        propertyId:
            'PT${DateTime.now().year}${widget.propertyId.padLeft(6, '0')}',
        address: '123 Main Street, Downtown',
        ward: 'Ward 5',
        zone: 'Zone A',
        latitude: 40.7128,
        longitude: -74.0060,
        areaSqft: 2500.0,
        propertyType: 'RESIDENTIAL',
        constructionType: 'RCC',
        yearBuilt: 2010,
        isActive: true,
        currentValuation: 500000.0,
        annualTax: 7500.0,
        images: [
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400',
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w-400',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      );

      setState(() {
        _property = mockProperty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load property: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToEdit() {
    if (_property != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPropertyScreen(property: _property),
        ),
      ).then((value) {
        if (value == true) {
          _loadProperty(); // Refresh after edit
        }
      });
    }
  }

  void _navigateToTransferOwnership() {
    if (_property != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OwnershipTransferScreen(
            propertyId: _property!.id.toString(),
            propertyName: _property!.propertyId,
          ),
        ),
      ).then((value) {
        if (value == true) {
          _loadProperty(); // Refresh after transfer
        }
      });
    }
  }

  void _navigateToValuation() {
    if (_property != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValuationScreen(
            propertyId: _property!.id.toString(),
            currentValuation: _property!.currentValuation ?? 0.0,
          ),
        ),
      ).then((value) {
        if (value == true) {
          _loadProperty(); // Refresh after valuation
        }
      });
    }
  }

  void _navigateToTaxDetails() {
    if (_property != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaxDetailsScreen(
            propertyId: _property!.id.toString(),
            propertyTax: _property!.annualTax ?? 0.0,
          ),
        ),
      );
    }
  }

  void _showImageGallery(int initialIndex) {
    if (_property != null && _property!.images.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewer(
            images: _property!.images,
            initialIndex: initialIndex,
            propertyId: _property!.propertyId,
          ),
        ),
      );
    }
  }

  void _showLocationOnMap() {
    if (_property != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Location - ${_property!.propertyId}')),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_property!.latitude, _property!.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(_property!.propertyId),
                  position: LatLng(_property!.latitude, _property!.longitude),
                  infoWindow: InfoWindow(
                    title: _property!.propertyId,
                    snippet: _property!.address,
                  ),
                ),
              },
              myLocationEnabled: true,
            ),
          ),
        ),
      );
    }
  }

  void _generateReport() {
    // Generate property report
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Report'),
        content: const Text('Select report type:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadReport('detailed');
            },
            child: const Text('Detailed Report'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadReport('summary');
            },
            child: const Text('Summary Report'),
          ),
        ],
      ),
    );
  }

  void _downloadReport(String type) {
    // Implement report download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type report generated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _togglePropertyStatus() {
    if (_property != null) {
      setState(() {
        _property = _property!.copyWith(isActive: !_property!.isActive);
      });

      // In real app, update via API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Property ${_property!.isActive ? 'activated' : 'deactivated'}',
          ),
          backgroundColor: _property!.isActive ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Property Details', showBackButton: true),
        body: LoadingIndicator(message: 'Loading property...'),
      );
    }

    if (_property == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Property Details',
          showBackButton: true,
        ),
        body: ErrorWidget(message: 'Property not found', showRetry: true),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Property Details',
        showBackButton: true,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEdit),
          IconButton(icon: const Icon(Icons.print), onPressed: _generateReport),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'transfer':
                  _navigateToTransferOwnership();
                  break;
                case 'valuation':
                  _navigateToValuation();
                  break;
                case 'tax':
                  _navigateToTaxDetails();
                  break;
                case 'toggle_status':
                  _togglePropertyStatus();
                  break;
                case 'delete':
                  _confirmDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'transfer',
                child: ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text('Transfer Ownership'),
                ),
              ),
              const PopupMenuItem(
                value: 'valuation',
                child: ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text('New Valuation'),
                ),
              ),
              const PopupMenuItem(
                value: 'tax',
                child: ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Tax Details'),
                ),
              ),
              const PopupMenuItem(
                value: 'toggle_status',
                child: ListTile(
                  leading: Icon(Icons.power_settings_new),
                  title: Text(_property!.isActive ? 'Deactivate' : 'Activate'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Delete Property',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == index
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontWeight: _selectedTab == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _selectedTab == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Content
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: // Overview
        return _buildOverviewTab();
      case 1: // Valuation
        return _buildValuationTab();
      case 2: // Taxation
        return _buildTaxationTab();
      case 3: // Ownership
        return _buildOwnershipTab();
      case 4: // Documents
        return _buildDocumentsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _property!.propertyId,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(
                label: Text(
                  _property!.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: _property!.isActive
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                labelColor: _property!.isActive ? Colors.green : Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Address
          Text(
            _property!.address,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          // Images Gallery
          if (_property!.images.isNotEmpty) ...[
            Text(
              'Property Images',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _property!.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showImageGallery(index),
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(
                        right: index < _property!.images.length - 1 ? 8 : 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(_property!.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Location Map Preview
          Text('Location', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showLocationOnMap,
            child: PropertyMapPreview(
              latitude: _property!.latitude,
              longitude: _property!.longitude,
              address: _property!.address,
            ),
          ),
          const SizedBox(height: 16),

          // Property Details Grid
          Text(
            'Property Details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildDetailItem(
                icon: Icons.category,
                label: 'Type',
                value: _property!.propertyType,
              ),
              _buildDetailItem(
                icon: Icons.construction,
                label: 'Construction',
                value: _property!.constructionType,
              ),
              _buildDetailItem(
                icon: Icons.square_foot,
                label: 'Area',
                value: '${_property!.areaSqft} sq ft',
              ),
              _buildDetailItem(
                icon: Icons.calendar_today,
                label: 'Year Built',
                value: _property!.yearBuilt.toString(),
              ),
              _buildDetailItem(
                icon: Icons.apartment,
                label: 'Ward',
                value: _property!.ward,
              ),
              _buildDetailItem(
                icon: Icons.map,
                label: 'Zone',
                value: _property!.zone,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Actions
          Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.swap_horiz, size: 16),
                label: const Text('Transfer Ownership'),
                onPressed: _navigateToTransferOwnership,
              ),
              ActionChip(
                avatar: const Icon(Icons.assessment, size: 16),
                label: const Text('New Valuation'),
                onPressed: _navigateToValuation,
              ),
              ActionChip(
                avatar: const Icon(Icons.receipt, size: 16),
                label: const Text('Tax Payment'),
                onPressed: _navigateToTaxDetails,
              ),
              ActionChip(
                avatar: const Icon(Icons.print, size: 16),
                label: const Text('Generate Report'),
                onPressed: _generateReport,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValuationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Valuation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Valuation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _navigateToValuation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_property!.currentValuation != null ? '\$${_property!.currentValuation!.toStringAsFixed(2)}' : 'Not valued'}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (_property!.currentValuation != null)
                    Text(
                      'Last updated: ${_property!.updatedAt.toString().split(' ')[0]}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Valuation History (mock data)
          Text(
            'Valuation History',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              final year = 2023 - index;
              final value = 500000 - (index * 50000);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.assessment, color: Colors.blue),
                  title: Text('Valuation $year'),
                  subtitle: Text('Completed on ${year}-01-15'),
                  trailing: Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),

          // New Valuation Button
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _navigateToValuation,
              icon: const Icon(Icons.add_chart),
              label: const Text('New Valuation'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxationTab() {
    // Mock tax data
    final currentYear = DateTime.now().year;
    final taxHistory = List.generate(3, (index) {
      final year = currentYear - index;
      final amount = 7500 - (index * 500);
      final paid = index == 0; // Current year not paid yet

      return {
        'year': year,
        'amount': amount,
        'paid': paid,
        'dueDate': '$year-12-31',
        'paymentDate': paid ? '$year-06-15' : null,
      };
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Annual Tax
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Annual Property Tax',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_property!.annualTax?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: const Text('CURRENT YEAR'),
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        labelColor: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Due: ${currentYear}-12-31',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPaymentStat(
                        label: 'Paid',
                        value: '2 Years',
                        color: Colors.green,
                      ),
                      _buildPaymentStat(
                        label: 'Pending',
                        value: '1 Year',
                        color: Colors.orange,
                      ),
                      _buildPaymentStat(
                        label: 'Total',
                        value:
                            '\$${(_property!.annualTax! * 3).toStringAsFixed(2)}',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tax History
          Text('Tax History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: taxHistory.length,
            itemBuilder: (context, index) {
              final tax = taxHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    tax['paid'] as bool ? Icons.check_circle : Icons.pending,
                    color: tax['paid'] as bool ? Colors.green : Colors.orange,
                  ),
                  title: Text('Property Tax ${tax['year']}'),
                  subtitle: Text('Due: ${tax['dueDate']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${(tax['amount'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tax['paid'] as bool ? 'PAID' : 'PENDING',
                        style: TextStyle(
                          color: tax['paid'] as bool
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!(tax['paid'] as bool)) {
                      _showPaymentDialog(
                        tax['year'] as int,
                        tax['amount'] as double,
                      );
                    }
                  },
                ),
              );
            },
          ),

          // Pay Tax Button
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () =>
                  _showPaymentDialog(currentYear, _property!.annualTax ?? 0.0),
              icon: const Icon(Icons.payment),
              label: const Text('Pay Current Year Tax'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnershipTab() {
    // Mock ownership history
    final ownershipHistory = [
      {
        'owner': 'John Doe',
        'from': '2020-01-15',
        'to': 'Present',
        'transferType': 'Purchase',
        'document': 'Deed #12345',
      },
      {
        'owner': 'Jane Smith',
        'from': '2015-03-20',
        'to': '2020-01-14',
        'transferType': 'Inheritance',
        'document': 'Will #67890',
      },
      {
        'owner': 'Robert Johnson',
        'from': '2010-05-10',
        'to': '2015-03-19',
        'transferType': 'Purchase',
        'document': 'Deed #54321',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Owner
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Owner',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: const Text('John Doe'),
                    subtitle: const Text('Owner since 2020-01-15'),
                    trailing: Chip(
                      label: const Text('CURRENT'),
                      backgroundColor: Colors.green.withOpacity(0.2),
                      labelColor: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('john.doe@email.com'),
                          Text('+1 234-567-8900'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('456 Owner Street'),
                          Text('New York, NY 10001'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Transfer Ownership Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _navigateToTransferOwnership,
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Transfer Ownership'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ownership History
          Text(
            'Ownership History',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ownershipHistory.length,
            itemBuilder: (context, index) {
              final owner = ownershipHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.purple),
                  title: Text(owner['owner'] as String),
                  subtitle: Text('${owner['from']} - ${owner['to']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        owner['transferType'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        owner['document'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    // Mock documents
    final documents = [
      {
        'name': 'Property Deed',
        'type': 'PDF',
        'size': '2.4 MB',
        'date': '2020-01-15',
      },
      {
        'name': 'Tax Receipt 2023',
        'type': 'PDF',
        'size': '1.1 MB',
        'date': '2023-06-15',
      },
      {
        'name': 'Valuation Report',
        'type': 'PDF',
        'size': '3.2 MB',
        'date': '2023-01-20',
      },
      {
        'name': 'Survey Map',
        'type': 'Image',
        'size': '4.5 MB',
        'date': '2020-02-10',
      },
      {
        'name': 'Building Permit',
        'type': 'PDF',
        'size': '1.8 MB',
        'date': '2010-03-15',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload Button
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upload Documents',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Upload property-related documents',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _uploadDocument,
                    icon: const Icon(Icons.add),
                    label: const Text('Upload'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Documents List
          Text(
            'Documents (${documents.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      doc['type'] == 'PDF' ? Icons.picture_as_pdf : Icons.image,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(doc['name'] as String),
                  subtitle: Text(
                    '${doc['type']} • ${doc['size']} • ${doc['date']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () =>
                            _downloadDocument(doc['name'] as String),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _shareDocument(doc['name'] as String),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStat({
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
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showPaymentDialog(int year, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.payment, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Property Tax $year',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: \$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text('Select payment method:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Credit Card'),
                  selected: true,
                  onSelected: (_) {},
                ),
                const ChoiceChip(label: Text('Bank Transfer'), selected: false),
                const ChoiceChip(label: Text('Cash'), selected: false),
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
              _processPayment(year, amount);
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _processPayment(int year, double amount) {
    // Process payment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment of \$${amount.toStringAsFixed(2)} for $year processed successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _uploadDocument() async {
    // Implement document upload
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: const Text('Select document type:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document upload initiated'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  void _downloadDocument(String documentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $documentName...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _shareDocument(String documentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $documentName...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? '
          'This action cannot be undone and will delete all associated data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProperty();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Property'),
          ),
        ],
      ),
    );
  }

  void _deleteProperty() async {
    try {
      // Delete property
      await ref
          .read(propertyProvider.notifier)
          .deleteProperty(widget.propertyId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after delay
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to delete property: $e');
    }
  }
}
