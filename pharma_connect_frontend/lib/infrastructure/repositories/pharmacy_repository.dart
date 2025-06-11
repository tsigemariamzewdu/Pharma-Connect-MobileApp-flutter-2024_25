import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/pharmacy_api.dart';

class PharmacyRepository {
  final PharmacyApi api;

  PharmacyRepository(this.api);

  Future<List<Pharmacy>> getAllPharmacies() => api.getAll();
  Future<Pharmacy> addPharmacy(Pharmacy pharmacy) => api.add(pharmacy);
  Future<Pharmacy> updatePharmacy(String id, Pharmacy pharmacy) => api.update(id, pharmacy);
  Future<void> deletePharmacy(String id) => api.delete(id);
} 