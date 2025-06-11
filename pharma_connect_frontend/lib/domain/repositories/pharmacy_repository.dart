import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';

abstract class PharmacyRepository {
  Future<Pharmacy> getPharmacy(String id);
  Future<Pharmacy> updatePharmacy(String id, Map<String, dynamic> data);
  Future<void> deletePharmacy(String id);
  Future<List<Pharmacy>> getPharmacies();
}
