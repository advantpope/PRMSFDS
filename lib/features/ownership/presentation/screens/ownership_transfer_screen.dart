import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:property_tax_system_fd/shared/widgets/custom_app_bar.dart';
import 'package:property_tax_system_fd/shared/utils/form_validators.dart';
import 'package:property_tax_system_fd/shared/widgets/error_dialog.dart';

class OwnershipTransferScreen extends ConsumerStatefulWidget {
  const OwnershipTransferScreen({
    super.key,
    required this.propertyId,
    required this.propertyName,
    this.currentOwnerName,
  });
  final int propertyId;
  final String propertyName;
  final dynamic currentOwnerName;

  @override
  ConsumerState<OwnershipTransferScreen> createState() =>
      _OwnershipTransferScreenState();
}

class _OwnershipTransferScreenState
    extends ConsumerState<OwnershipTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newOwnerNameController = TextEditingController();
  final _newOwnerPhoneController = TextEditingController();
  final _newOwnerEmailController = TextEditingController();
  final _newOwnerAddressController = TextEditingController();
  final _transferReasonController = TextEditingController();
  final _transferCommentsController = TextEditingController();
  final _documentNumberController = TextEditingController();

  String _selectedTransferType = 'SALE';
  DateTime _transferDate = DateTime.now();
  bool _isSubmitting = false;
  bool _hasExistingOwner = false;
  final List<FileInfo> _uploadedDocuments = [];

  // Transfer types
  final List<String> _transferTypes = [
    'SALE',
    'INHERITANCE',
    'GIFT',
    'FORECLOSURE',
    'LEASE_ASSIGNMENT',
    'PARTITION',
    'SETTLEMENT',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    _hasExistingOwner =
        widget.currentOwnerName != null && widget.currentOwnerName!.isNotEmpty;
  }

  @override
  void dispose() {
    _newOwnerNameController.dispose();
    _newOwnerPhoneController.dispose();
    _newOwnerEmailController.dispose();
    _newOwnerAddressController.dispose();
    _transferReasonController.dispose();
    _transferCommentsController.dispose();
    _documentNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickTransferDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _transferDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _transferDate) {
      setState(() => _transferDate = pickedDate);
    }
  }

  Future<void> _uploadDocument() async {
    // Simulate document upload
    // In a real app, you would use file_picker or image_picker
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: const Text('Select document type:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateDocumentUpload('DEED');
            },
            child: const Text('Property Deed'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateDocumentUpload('SALE_AGREEMENT');
            },
            child: const Text('Sale Agreement'),
          ),
        ],
      ),
    );
  }

  void _simulateDocumentUpload(String type) {
    setState(() {
      _uploadedDocuments.add(
        FileInfo(
          name: '$type Document ${_uploadedDocuments.length + 1}',
          type: 'PDF',
          size: '1.${_uploadedDocuments.length + 1} MB',
          uploadedAt: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document uploaded successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeDocument(int index) {
    setState(() {
      _uploadedDocuments.removeAt(index);
    });
  }

  Future<void> _submitTransfer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_uploadedDocuments.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Missing Documents',
          message:
              'Please upload at least one supporting document for the transfer.',
        ),
      );
      return;
    }

    // Confirm transfer
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to transfer ownership?'),
            const SizedBox(height: 12),
            Text('Property: ${widget.propertyName}'),
            const SizedBox(height: 8),
            Text('New Owner: ${_newOwnerNameController.text}'),
            const SizedBox(height: 8),
            Text('Transfer Type: $_selectedTransferType'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Confirm Transfer'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ownership transfer completed successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Print Receipt',
            onPressed: _printTransferReceipt,
          ),
        ),
      );

      // Return success to previous screen
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Transfer Failed',
          message: 'Failed to transfer ownership: $e',
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _printTransferReceipt() {
    // Implement printing logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Receipt'),
        content: const Text('Transfer receipt printed successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Transfer Ownership',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Information
              _buildPropertyInfoCard(),
              const SizedBox(height: 24),

              // Transfer Details
              const Text(
                'Transfer Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Transfer Type
                      DropdownButtonFormField<String>(
                        value: _selectedTransferType,
                        decoration: const InputDecoration(
                          labelText: 'Transfer Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.swap_horiz),
                        ),
                        items: _transferTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_formatTransferType(type)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedTransferType = value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select transfer type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Transfer Date
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(_transferDate),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Transfer Date',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: _pickTransferDate,
                          ),
                        ),
                        validator: FormValidators.required,
                      ),
                      const SizedBox(height: 16),

                      // Transfer Reason
                      TextFormField(
                        controller: _transferReasonController,
                        decoration: const InputDecoration(
                          labelText: 'Transfer Reason',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          hintText: 'e.g., Property sale, inheritance, etc.',
                        ),
                        maxLines: 2,
                        validator: FormValidators.required,
                      ),
                      const SizedBox(height: 16),

                      // Document Number
                      TextFormField(
                        controller: _documentNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Document Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers),
                          hintText: 'e.g., Deed number, agreement number',
                        ),
                        validator: FormValidators.required,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // New Owner Information
              const Text(
                'New Owner Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Owner Name
                      TextFormField(
                        controller: _newOwnerNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Enter full name',
                        ),
                        validator: FormValidators.required,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextFormField(
                        controller: _newOwnerPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Enter phone number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: FormValidators.phoneNumber,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _newOwnerEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Enter email address',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return FormValidators.email(value);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _newOwnerAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Address (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'Enter physical address',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Supporting Documents
              const Text(
                'Supporting Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload supporting documents for the transfer:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Property Deed\n• Sale Agreement\n• Transfer Form\n• Identity Documents',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Upload Button
                      ElevatedButton.icon(
                        onPressed: _uploadDocument,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Document'),
                      ),
                      const SizedBox(height: 16),

                      // Uploaded Documents List
                      if (_uploadedDocuments.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'No documents uploaded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _uploadedDocuments.length,
                          itemBuilder: (context, index) {
                            final doc = _uploadedDocuments[index];
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.blue,
                                ),
                              ),
                              title: Text(doc.name),
                              subtitle: Text(
                                '${doc.type} • ${doc.size} • ${DateFormat('MMM dd, yyyy').format(doc.uploadedAt)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeDocument(index),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Additional Comments
              const Text(
                'Additional Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _transferCommentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                  hintText: 'Any additional comments about the transfer',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitTransfer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('TRANSFER OWNERSHIP'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfoCard() {
    return Card(
      color: Colors.blue[50],
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
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Property ID: ${widget.propertyId}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.apartment, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Property: ${widget.propertyName}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (_hasExistingOwner) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Current Owner: ${widget.currentOwnerName}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Current Owner: Not Assigned',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTransferType(String type) {
    return type
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

class FileInfo {
  final String name;
  final String type;
  final String size;
  final DateTime uploadedAt;

  FileInfo({
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedAt,
  });
}
