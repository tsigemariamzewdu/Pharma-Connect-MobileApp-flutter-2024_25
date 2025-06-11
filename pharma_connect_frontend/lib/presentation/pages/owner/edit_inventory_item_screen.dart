import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/inventory_api.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/inventory_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/inventory_notifier.dart';

class EditInventoryItemScreen extends ConsumerStatefulWidget {
  final InventoryItem item;
  const EditInventoryItemScreen({Key? key, required this.item})
      : super(key: key);

  @override
  ConsumerState<EditInventoryItemScreen> createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState
    extends ConsumerState<EditInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _expiryDateController;
  late TextEditingController _categoryController;
  DateTime? _selectedExpiryDate;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    _priceController =
        TextEditingController(text: widget.item.price.toStringAsFixed(2));
    _expiryDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.item.expiryDate));
    _categoryController =
        TextEditingController(text: widget.item.category ?? '');
    _selectedExpiryDate = widget.item.expiryDate;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _expiryDateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? DateTime.now(),
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
    if (!_formKey.currentState!.validate()) {
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
        'quantity': int.parse(_quantityController.text),
        'price': double.parse(_priceController.text),
        'expiryDate': _selectedExpiryDate!.toIso8601String(),
        'category': _categoryController.text,
        'updatedBy': userId,
        'medicineId': widget.item.medicineId,
        'medicineName': widget.item.medicineName,
        'pharmacy': pharmacyId,
      };
      await ref
          .read(inventoryProvider(pharmacyId).notifier)
          .updateInventoryItem(widget.item.id, data);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _error = null;
        });
        Navigator.of(context).pop(true);
      }
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Inventory Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Medicine: ${widget.item.medicineName}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity *'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter quantity' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price *'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date *',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _pickExpiryDate(context),
                validator: (value) => value == null || value.isEmpty
                    ? 'Select expiry date'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () => _submitForm(pharmacyId, userId),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
