import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/medicine_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';

class AdminMedicinesScreen extends ConsumerWidget {
  AdminMedicinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadMedicines(),
          ),
        ],
      ),
      body: medicineState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (medicines) => _buildMedicineList(context, notifier, medicines),
      ),
    );
  }

  Widget _buildMedicineList(BuildContext context, MedicineNotifier notifier,
      List<Medicine> medicines) {
    if (medicines.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64),
            SizedBox(height: 16),
            Text('No medicines found'),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => notifier.loadMedicines(),
      child: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) =>
            _buildMedicineItem(context, notifier, medicines[index]),
      ),
    );
  }

  Widget _buildMedicineItem(
      BuildContext context, MedicineNotifier notifier, Medicine medicine) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: medicine.image.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  medicine.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.medication),
                ),
              )
            : const Icon(Icons.medication, size: 48),
        title: Text(
          medicine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${medicine.category}'),
            if (medicine.description.isNotEmpty)
              Text(
                medicine.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) =>
              _handleMedicineAction(context, notifier, value, medicine),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  void _handleMedicineAction(BuildContext context, MedicineNotifier notifier,
      String action, Medicine medicine) async {
    switch (action) {
      case 'edit':
        final result = await Navigator.pushNamed(
          context,
          '/medicine/edit',
          arguments: medicine,
        );
        if (result != null) {
          notifier.loadMedicines();
        }
        break;
      case 'delete':
        _showDeleteConfirmation(context, notifier, medicine);
        break;
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, MedicineNotifier notifier, Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await notifier.deleteMedicine(medicine.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine deleted successfully!')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
