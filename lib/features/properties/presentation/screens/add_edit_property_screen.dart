import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_tax_system_fd/core/services/location_service.dart';
import 'package:property_tax_system_fd/core/services/permission_service.dart';
import 'package:property_tax_system_fd/features/properties/presentation/providers/property_provider.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/location_picker_screen.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/widgets/loading_indicator.dart';
import 'package:property_tax_system_fd/shared/widgets/error_dialog.dart';
import 'package:property_tax_system_fd/shared/utils/form_validators.dart';

class AddPropertyScreen extends ConsumerStatefulWidget {
  final PropertyModel? property;

  const AddPropertyScreen({super.key, this.property});

  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form controllers
  final _propertyIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _wardController = TextEditingController();
  final _zoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _yearBuiltController = TextEditingController();

  // Selected values
  String? _selectedPropertyType;
  String? _selectedConstructionType;
  LatLng? _selectedLocation;
  List<String> _selectedImages = [];

  // Loading states
  bool _isSubmitting = false;
  bool _isLoadingLocation = false;
  bool _isUploadingImages = false;

  // Property types (should match Django model choices)
  final List<String> _propertyTypes = [
    'RESIDENTIAL',
    'COMMERCIAL',
    'INDUSTRIAL',
    'AGRICULTURAL',
    'VACANT_LAND',
  ];

  final List<String> _constructionTypes = [
    'RCC',
    'FRAMED',
    'LOAD_BEARING',
    'STEEL',
    'WOOD',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.property != null) {
      final property = widget.property!;
      _propertyIdController.text = property.propertyId;
      _addressController.text = property.address;
      _wardController.text = property.ward;
      _zoneController.text = property.zone;
      _areaController.text = property.areaSqft.toString();
      _yearBuiltController.text = property.yearBuilt.toString();
      _selectedPropertyType = property.propertyType;
      _selectedConstructionType = property.constructionType;
      _selectedLocation = LatLng(property.latitude, property.longitude);
      _selectedImages = List.from(property.images);
    } else {
      // Generate auto property ID
      _propertyIdController.text = _generatePropertyId();
    }
  }

  String _generatePropertyId() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final random = (now.millisecondsSinceEpoch % 10000).toString().padLeft(
      4,
      '0',
    );
    return 'PT$year$month$day$random';
  }

  @override
  void dispose() {
    _propertyIdController.dispose();
    _addressController.dispose();
    _wardController.dispose();
    _zoneController.dispose();
    _areaController.dispose();
    _yearBuiltController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoadingLocation = true);

      // Request location permission
      final hasPermission = await PermissionService.requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      // Get current position
      final position = await LocationService.getCurrentPosition();

      // Get address from coordinates
      final address = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _addressController.text = address;

        // Try to extract ward and zone from address
        _extractWardAndZone(address);
      });
    } catch (e) {
      _showError('Failed to get location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _extractWardAndZone(String address) {
    // Simple extraction logic - in real app, you might want more sophisticated logic
    if (address.toLowerCase().contains('ward')) {
      final words = address.split(' ');
      for (int i = 0; i < words.length; i++) {
        if (words[i].toLowerCase() == 'ward' && i + 1 < words.length) {
          _wardController.text = words[i + 1];
          break;
        }
      }
    }

    // Set default zone if not set
    if (_zoneController.text.isEmpty) {
      _zoneController.text = 'A';
    }
  }

  Future<void> _pickImages() async {
    try {
      // Request storage permission
      final hasPermission = await PermissionService.requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // In real app, you would upload these to your Django backend
        // For now, we'll just store the file paths
        final filePaths = result.files.map((file) => file.path!).toList();
        setState(() {
          _selectedImages.addAll(filePaths);
        });
      }
    } catch (e) {
      _showError('Failed to pick images: $e');
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _openLocationPicker() async {
    if (_selectedLocation == null) {
      await _getCurrentLocation();
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationPickerScreen(initialLocation: _selectedLocation),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
      });

      // Get address for the selected location
      try {
        final address = await LocationService.getAddressFromLatLng(
          result.latitude,
          result.longitude,
        );
        _addressController.text = address;
      } catch (e) {
        print('Failed to get address: $e');
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      _showError('Please select a location for the property');
      return;
    }

    if (_selectedPropertyType == null) {
      _showError('Please select a property type');
      return;
    }

    if (_selectedConstructionType == null) {
      _showError('Please select a construction type');
      return;
    }

    try {
      setState(() => _isSubmitting = true);

      final property = PropertyModel(
        id: widget.property?.id ?? 0, // 0 for new properties
        propertyId: _propertyIdController.text.trim(),
        address: _addressController.text.trim(),
        ward: _wardController.text.trim(),
        zone: _zoneController.text.trim(),
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        areaSqft: double.parse(_areaController.text),
        propertyType: _selectedPropertyType!,
        constructionType: _selectedConstructionType!,
        yearBuilt: int.parse(_yearBuiltController.text),
        isActive: true,
        currentOwner: widget.property?.currentOwner,
        currentValuation: widget.property?.currentValuation ?? 0.0,
        annualTax: widget.property?.annualTax ?? 0.0,
        images: _selectedImages,
        createdAt: widget.property?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.property != null) {
        // Update existing property
        await ref.read(propertyProvider.notifier).updateProperty(property);
        _showSuccess('Property updated successfully!');
      } else {
        // Add new property
        await ref.read(propertyProvider.notifier).addProperty(property);
        _showSuccess('Property added successfully!');
      }

      // Navigate back after a delay
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to save property: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(title: 'Error', message: message),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: widget.property != null ? 'Edit Property' : 'Add New Property',
        showBackButton: true,
        actions: [
          if (widget.property != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: _isSubmitting
          ? const LoadingIndicator(message: 'Saving property...')
          : _buildFormContent(),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Property ID
            _buildTextField(
              controller: _propertyIdController,
              label: 'Property ID',
              icon: Icons.qr_code,
              readOnly: true,
            ),
            const SizedBox(height: 16),

            // Location Section
            _buildLocationSection(),
            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              validator: FormValidators.required,
            ),
            const SizedBox(height: 16),

            // Ward and Zone Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _wardController,
                    label: 'Ward',
                    icon: Icons.apartment,
                    validator: FormValidators.required,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _zoneController,
                    label: 'Zone',
                    icon: Icons.map,
                    validator: FormValidators.required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Area and Year Built Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _areaController,
                    label: 'Area (sq ft)',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.positiveNumber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _yearBuiltController,
                    label: 'Year Built',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.yearBuilt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Property Type Dropdown
            _buildDropdown(
              value: _selectedPropertyType,
              label: 'Property Type',
              items: _propertyTypes,
              onChanged: (value) {
                setState(() => _selectedPropertyType = value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a property type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Construction Type Dropdown
            _buildDropdown(
              value: _selectedConstructionType,
              label: 'Construction Type',
              items: _constructionTypes,
              onChanged: (value) {
                setState(() => _selectedConstructionType = value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a construction type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Images Section
            _buildImagesSection(),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.property != null
                          ? 'UPDATE PROPERTY'
                          : 'ADD PROPERTY',
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                icon: _isLoadingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _isLoadingLocation
                      ? 'Getting Location...'
                      : 'Use Current Location',
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _openLocationPicker,
              icon: const Icon(Icons.map),
              label: const Text('Pick on Map'),
            ),
          ],
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selected: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
              '${_selectedLocation!.longitude.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category),
      ),
      items: items.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(_formatEnumValue(type)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  String _formatEnumValue(String value) {
    return value
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Property Images',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Images'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_selectedImages.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.photo_library, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No images selected',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add photos of the property',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(_selectedImages[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? This action cannot be undone.',
        ),
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
        await ref
            .read(propertyProvider.notifier)
            .deleteProperty(widget.property!.id.toString());
        _showSuccess('Property deleted successfully!');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        _showError('Failed to delete property: $e');
      }
    }
  }
}
