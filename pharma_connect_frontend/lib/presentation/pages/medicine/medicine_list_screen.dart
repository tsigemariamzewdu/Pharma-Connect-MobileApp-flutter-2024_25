import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/medicine_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/presentation/widgets/loading_indicator.dart';
import 'package:pharma_connect_flutter/presentation/widgets/error_dialog.dart';

class MedicineListScreen extends ConsumerStatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends ConsumerState<MedicineListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(medicineProvider.notifier).loadMedicines());
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              onChanged: (query) {
                setState(() => _searchQuery = query);
                if (query.isEmpty) {
                  ref.read(medicineProvider.notifier).loadMedicines();
                } else {
                  // Optionally implement search in the notifier
                  // ref.read(medicineProvider.notifier).searchMedicines(query);
                }
              },
            ),
          ),
          Expanded(
            child: medicineState.when(
              loading: () => const LoadingIndicator(),
              data: (medicines) => MedicineList(
                medicines: medicines,
                onDelete: (id) async {
                  await ref.read(medicineProvider.notifier).deleteMedicine(id);
                },
              ),
              error: (err, _) => Center(child: Text(err.toString())),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search medicines...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class MedicineList extends StatelessWidget {
  final List<Medicine> medicines;
  final Future<void> Function(String id) onDelete;

  const MedicineList({
    Key? key,
    required this.medicines,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return MedicineCard(
          medicine: medicine,
          onDelete: () => onDelete(medicine.id),
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onDelete;

  const MedicineCard({
    Key? key,
    required this.medicine,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(medicine.name),
        subtitle: Text(medicine.description),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/medicine/details',
            arguments: medicine,
          );
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.pushNamed(
                context,
                '/medicine/edit',
                arguments: medicine,
              );
            } else if (value == 'delete') {
              onDelete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine deleted successfully!')),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
