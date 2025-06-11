import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/application/notifiers/pharmacy_notifier.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPharmacyScreen extends ConsumerStatefulWidget {
  final Pharmacy pharmacy;
  const EditPharmacyScreen({Key? key, required this.pharmacy})
      : super(key: key);

  @override
  ConsumerState<EditPharmacyScreen> createState() => _EditPharmacyScreenState();
}

class _EditPharmacyScreenState extends ConsumerState<EditPharmacyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _emailController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pharmacy.name);
    _ownerNameController =
        TextEditingController(text: widget.pharmacy.ownerName);
    _licenseNumberController =
        TextEditingController(text: widget.pharmacy.licenseNumber);
    _emailController = TextEditingController(text: widget.pharmacy.email);
    _contactNumberController =
        TextEditingController(text: widget.pharmacy.contactNumber);
    _addressController = TextEditingController(text: widget.pharmacy.address);
    _cityController = TextEditingController(text: widget.pharmacy.city);
    _stateController = TextEditingController(text: widget.pharmacy.state);
    _zipCodeController = TextEditingController(text: widget.pharmacy.zipCode);
    _latitudeController =
        TextEditingController(text: widget.pharmacy.latitude.toString());
    _longitudeController =
        TextEditingController(text: widget.pharmacy.longitude.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _licenseNumberController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = {
        'name': _nameController.text,
        'ownerName': _ownerNameController.text,
        'licenseNumber': _licenseNumberController.text,
        'email': _emailController.text,
        'contactNumber': _contactNumberController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zipCode': _zipCodeController.text,
        'latitude': double.tryParse(_latitudeController.text) ?? 0.0,
        'longitude': double.tryParse(_longitudeController.text) ?? 0.0,
      };
      final notifier = ref.read(pharmacyProvider.notifier);
      await notifier.updatePharmacy(
          widget.pharmacy.id,
          widget.pharmacy.copyWith(
            name: _nameController.text,
            ownerName: _ownerNameController.text,
            licenseNumber: _licenseNumberController.text,
            email: _emailController.text,
            contactNumber: _contactNumberController.text,
            address: _addressController.text,
            city: _cityController.text,
            state: _stateController.text,
            zipCode: _zipCodeController.text,
            latitude: double.tryParse(_latitudeController.text) ?? 0.0,
            longitude: double.tryParse(_longitudeController.text) ?? 0.0,
          ));
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pharmacy')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Pharmacy Name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _ownerNameController,
                      decoration:
                          const InputDecoration(labelText: 'Owner Name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _licenseNumberController,
                      decoration:
                          const InputDecoration(labelText: 'License Number'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contactNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Contact Number'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(labelText: 'Zip Code'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
