import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/pharmacy_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';

class AdminPharmaciesScreen extends ConsumerStatefulWidget {
  const AdminPharmaciesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminPharmaciesScreen> createState() =>
      _AdminPharmaciesScreenState();
}

class _AdminPharmaciesScreenState extends ConsumerState<AdminPharmaciesScreen> {
  String _search = '';
  final _searchController = TextEditingController();

  List<Pharmacy> _filterPharmacies(List<Pharmacy> pharmacies) {
    if (_search.isEmpty) return pharmacies;
    final query = _search.toLowerCase();
    return pharmacies.where((pharmacy) {
      return pharmacy.name.toLowerCase().contains(query) ||
          (pharmacy.city.toLowerCase().contains(query) ?? false) ||
          pharmacy.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyState = ref.watch(pharmacyProvider);
    final notifier = ref.read(pharmacyProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadPharmacies(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Pharmacies',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: pharmacyState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text(err.toString())),
              data: (pharmacies) {
                final filteredPharmacies = _filterPharmacies(pharmacies);
                if (filteredPharmacies.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildPharmacyList(filteredPharmacies, notifier);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _search.isEmpty
                ? 'No pharmacies found'
                : 'No pharmacies match your search',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyList(
      List<Pharmacy> pharmacies, PharmacyNotifier notifier) {
    return RefreshIndicator(
      onRefresh: () async => notifier.loadPharmacies(),
      child: ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                pharmacy.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pharmacy.address),
                  Text('City: ${pharmacy.city}'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) =>
                    _handlePopupSelection(context, notifier, value, pharmacy),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePopupSelection(BuildContext context, PharmacyNotifier notifier,
      String value, Pharmacy pharmacy) {
    if (value == 'delete') {
      _showDeleteConfirmation(context, notifier, pharmacy);
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, PharmacyNotifier notifier, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pharmacy'),
        content: Text('Are you sure you want to delete ${pharmacy.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.deletePharmacy(pharmacy.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pharmacy deleted successfully!')),
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
