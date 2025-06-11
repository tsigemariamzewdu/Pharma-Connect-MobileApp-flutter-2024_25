import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/application/notifiers/pharmacy_notifier.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_connect_flutter/presentation/pages/owner/edit_pharmacy_screen.dart';
import 'package:collection/collection.dart';

class MyPharmacyPage extends ConsumerStatefulWidget {
  const MyPharmacyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPharmacyPage> createState() => _MyPharmacyPageState();
}

class _MyPharmacyPageState extends ConsumerState<MyPharmacyPage> {
  Pharmacy? _pharmacy;
  bool _isLoading = true;
  String? _error;
  late SessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionManager = SessionManager(prefs);
    _loadPharmacy();
  }

  Future<void> _loadPharmacy() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      String? pharmacyId = _sessionManager.getPharmacyId();
      final userId = _sessionManager.getUserId();
      print('Session pharmacyId: $pharmacyId');
      print('Session userId: $userId');
      final notifier = ref.read(pharmacyProvider.notifier);
      final pharmacies = await notifier.repository.getPharmacies();
      print('Fetched pharmacies: \\n' + pharmacies.map((p) => p.id).join(', '));
      Pharmacy? pharmacy;
      if (pharmacyId != null) {
        pharmacy = pharmacies.firstWhereOrNull((p) => p.id == pharmacyId);
        print('Pharmacy found by pharmacyId: $pharmacy');
      }
      if (pharmacy == null && userId != null) {
        pharmacy = pharmacies.firstWhereOrNull((p) => p.ownerId == userId);
        print('Pharmacy found by ownerId: $pharmacy');
        if (pharmacy != null) {
          await _sessionManager.savePharmacyId(pharmacy.id);
        }
      }
      if (pharmacy == null) {
        setState(() {
          _error = 'No pharmacy found for this owner.';
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _pharmacy = pharmacy;
        _isLoading = false;
      });
    } catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains('404')) {
        errorMsg = 'Pharmacy not found.';
      }
      setState(() {
        _error = errorMsg;
        _isLoading = false;
      });
    }
  }

  void _navigateToEditPharmacy() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPharmacyScreen(pharmacy: _pharmacy!),
      ),
    );
    if (updated == true) {
      setState(() => _isLoading = true);
      await _loadPharmacy();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPharmacy,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pharmacy == null) {
      return const Center(
        child: Text('No pharmacy data available'),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Pharmacy',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _navigateToEditPharmacy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _pharmacy!.name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    context,
                    'Pharmacy Information',
                    [
                      _buildDetailRow('Owner Name', _pharmacy!.ownerName),
                      _buildDetailRow(
                          'License Number', _pharmacy!.licenseNumber),
                      _buildDetailRow('Email', _pharmacy!.email),
                      _buildDetailRow(
                          'Contact Number', _pharmacy!.contactNumber),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    context,
                    'Location Details',
                    [
                      _buildDetailRow('Address', _pharmacy!.address),
                      _buildDetailRow('City', _pharmacy!.city),
                      _buildDetailRow('State', _pharmacy!.state),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              const Text(
                                'Location on Map',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.map,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
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
