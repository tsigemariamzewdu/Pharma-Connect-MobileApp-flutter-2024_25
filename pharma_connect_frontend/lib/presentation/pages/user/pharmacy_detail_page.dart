import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/application/notifiers/pharmacy_notifier.dart';
import 'package:collection/collection.dart';

class PharmacyDetailPage extends ConsumerWidget {
  final String pharmacyId;
  const PharmacyDetailPage({Key? key, required this.pharmacyId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacyState = ref.watch(pharmacyProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Details'),
      ),
      body: pharmacyState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (pharmacies) {
          final pharmacy =
              pharmacies.firstWhereOrNull((p) => p.id == pharmacyId);
          if (pharmacy == null) {
            return const Center(child: Text('No data found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pharmacy.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildDetailRow('Owner Name:', pharmacy.ownerName),
                _buildDetailRow('License Number:', pharmacy.licenseNumber),
                _buildDetailRow('Email:', pharmacy.email),
                _buildDetailRow('Contact Number:', pharmacy.contactNumber),
                _buildDetailRow('Address:', pharmacy.address),
                _buildDetailRow('City:', pharmacy.city),
                _buildDetailRow('State:', pharmacy.state),
                if (pharmacy.pharmacyImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.network(pharmacy.pharmacyImage!),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
