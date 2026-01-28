import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/presentation/providers/property_provider.dart';
import 'package:property_tax_system_fd/features/properties/presentation/widgets/property_card.dart';
import 'package:property_tax_system_fd/features/properties/presentation/widgets/property_grid_card.dart';
import 'package:property_tax_system_fd/features/properties/presentation/widgets/property_mini_card.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  ViewMode _viewMode = ViewMode.list;
  String _filter = 'all';
  String _sortBy = 'recent';
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          // View Mode Toggle
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.list
                    ? ViewMode.grid
                    : ViewMode.list;
              });
            },
          ),
          // Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context, ref);
            },
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(propertyProvider.notifier).loadProperties(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters (if visible)
          if (_showFilters) _buildFilterBar(),

          // Properties List/Grid
          Expanded(
            child: propertiesAsync.when(
              data: (properties) {
                if (properties.isEmpty) {
                  return _buildEmptyState();
                }

                // Apply filters and sorting
                final filteredProperties = _applyFilters(properties);

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(propertyProvider.notifier)
                        .loadProperties(refresh: true);
                  },
                  child: _buildPropertyView(filteredProperties),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _buildErrorState(error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-property');
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
          // Filter by status
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _filter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Properties')),
                DropdownMenuItem(value: 'active', child: Text('Active Only')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(value: 'tax_due', child: Text('Tax Due')),
              ],
              onChanged: (value) {
                setState(() => _filter = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Filter',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Sort by
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              items: const [
                DropdownMenuItem(value: 'recent', child: Text('Most Recent')),
                DropdownMenuItem(
                  value: 'value_high',
                  child: Text('Value (High to Low)'),
                ),
                DropdownMenuItem(
                  value: 'value_low',
                  child: Text('Value (Low to High)'),
                ),
                DropdownMenuItem(
                  value: 'tax_high',
                  child: Text('Tax (High to Low)'),
                ),
                DropdownMenuItem(value: 'name', child: Text('Property ID')),
              ],
              onChanged: (value) {
                setState(() => _sortBy = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Sort By',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyView(List<PropertyModel> properties) {
    switch (_viewMode) {
      case ViewMode.list:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyCard(property: property);
          },
        );
      case ViewMode.grid:
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyGridCard(property: property);
          },
        );
      case ViewMode.mini:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyMiniCard(property: property, showTaxStatus: true);
          },
        );
    }
  }

  List<PropertyModel> _applyFilters(List<PropertyModel> properties) {
    List<PropertyModel> filtered = List.from(properties);

    // Apply status filter
    switch (_filter) {
      case 'active':
        filtered = filtered.where((p) => p.isActive).toList();
        break;
      case 'inactive':
        filtered = filtered.where((p) => !p.isActive).toList();
        break;
      case 'tax_due':
        filtered = filtered
            .where((p) => p.annualTax != null && p.annualTax! > 0)
            .toList();
        break;
    }

    // Apply sorting
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case 'value_high':
        filtered.sort(
          (a, b) =>
              (b.currentValuation ?? 0).compareTo(a.currentValuation ?? 0),
        );
        break;
      case 'value_low':
        filtered.sort(
          (a, b) =>
              (a.currentValuation ?? 0).compareTo(b.currentValuation ?? 0),
        );
        break;
      case 'tax_high':
        filtered.sort((a, b) => (b.annualTax ?? 0).compareTo(a.annualTax ?? 0));
        break;
      case 'name':
        filtered.sort((a, b) => a.propertyId.compareTo(b.propertyId));
        break;
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            'No Properties Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add your first property by tapping the + button',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Failed to load properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(propertyProvider.notifier)
                    .loadProperties(refresh: true);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    // Search dialog implementation
  }
}

enum ViewMode { list, grid, mini }
