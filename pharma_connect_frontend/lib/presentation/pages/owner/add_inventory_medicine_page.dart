import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/medicine_notifier.dart';
import 'package:pharma_connect_flutter/application/notifiers/inventory_notifier.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/inventory_api.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/inventory_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/medicine_repository_impl.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/medicine_api.dart';
import 'package:dio/dio.dart';

class AddInventoryMedicinePage extends ConsumerStatefulWidget {
  const AddInventoryMedicinePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddInventoryMedicinePage> createState() =>
      _AddInventoryMedicinePageState();
}

class _AddInventoryMedicinePageState
    extends ConsumerState<AddInventoryMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  Medicine? _selectedMedicine;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  DateTime? _selectedExpiryDate;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedExpiryDate = pickedDate;
        _expiryDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _submitForm(String pharmacyId, String userId) async {
    if (!_formKey.currentState!.validate() || _selectedMedicine == null) {
      setState(() {
        _error = 'Please fill all fields and make sure you are logged in.';
      });
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final data = {
        'medicineId': _selectedMedicine!.id,
        'medicineName': _selectedMedicine!.name,
        'pharmacy': pharmacyId,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'expiryDate': _selectedExpiryDate!.toIso8601String(),
        'category': _selectedMedicine!.category,
        'updatedBy': userId,
      };
      await ref
          .read(inventoryProvider(pharmacyId).notifier)
          .addInventoryItem(data);
      setState(() {
        _isSubmitting = false;
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine added to inventory!')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedMedicine = null;
        _selectedExpiryDate = null;
        _expiryDateController.clear();
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = ref.watch(sessionManagerProvider);
    final pharmacyId = sessionManager.getPharmacyId();
    final userId = sessionManager.getUserId();
    if (pharmacyId == null || userId == null) {
      return const Scaffold(
        body: Center(
            child: Text('Please complete your pharmacy profile and login.')),
      );
    }
    final medicineState = ref.watch(medicineProvider);
    List<Medicine> medicines = [];
    bool isLoading = false;
    String? error;
    medicineState.when(
      loading: () {
        isLoading = true;
      },
      error: (err, _) {
        error = err.toString();
      },
      data: (items) {
        medicines = items;
      },
    );
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child:
                      Text(error!, style: const TextStyle(color: Colors.red)))
              : medicines.isEmpty
                  ? const Center(child: Text('No medicines available'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add Medicine',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Add new medicine to your inventory',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<Medicine>(
                                value: medicines.contains(_selectedMedicine)
                                    ? _selectedMedicine
                                    : null,
                                items: medicines
                                    .map((medicine) =>
                                        DropdownMenuItem<Medicine>(
                                          value: medicine,
                                          child: Text(medicine.name),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMedicine = value;
                                  });
                                },
                                decoration:
                                    _getInputDecoration('Select medicine'),
                                validator: (value) =>
                                    value == null ? 'Select a medicine' : null,
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                context,
                                'Quantity',
                                TextFormField(
                                  controller: _quantityController,
                                  decoration:
                                      _getInputDecoration('Enter quantity'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Enter quantity'
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                context,
                                'Price',
                                TextFormField(
                                  controller: _priceController,
                                  decoration:
                                      _getInputDecoration('Enter price in Br'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Enter price'
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                context,
                                'Expiry Date',
                                TextFormField(
                                  controller: _expiryDateController,
                                  decoration:
                                      _getInputDecoration('Select expiry date'),
                                  readOnly: true,
                                  onTap: () => _pickExpiryDate(context),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Select expiry date'
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (_error != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(_error!,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                ),
                              ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _submitForm(pharmacyId, userId),
                                child: _isSubmitting
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text('Add to Inventory'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildFormField(BuildContext context, String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
