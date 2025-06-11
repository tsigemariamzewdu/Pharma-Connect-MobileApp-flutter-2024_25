import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/medicine_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/presentation/widgets/loading_indicator.dart';
import 'package:pharma_connect_flutter/presentation/widgets/error_dialog.dart';

class AddMedicineScreen extends ConsumerWidget {
  const AddMedicineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine to Platform'),
      ),
      body: medicineState.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (_) => AddMedicineForm(notifier: notifier),
      ),
    );
  }
}

class AddMedicineForm extends StatefulWidget {
  final MedicineNotifier notifier;
  const AddMedicineForm({Key? key, required this.notifier}) : super(key: key);

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final medicine = Medicine(
        id: '', // Will be assigned by the server
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        image: _imageController.text,
      );
      await widget.notifier.addMedicine(medicine);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine added successfully!')),
      );
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Medicine Name *'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category *'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a category' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL *',
                hintText: 'Provide a publicly accessible URL.',
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter an image URL' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
