import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/pharmacy_repository_impl.dart';

class PharmacyNotifier extends StateNotifier<AsyncValue<List<Pharmacy>>> {
  final PharmacyRepositoryImpl repository;

  PharmacyNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadPharmacies();
  }

  Future<void> loadPharmacies() async {
    state = const AsyncValue.loading();
    try {
      final pharmacies = await repository.getPharmacies();
      state = AsyncValue.data(pharmacies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPharmacy(Pharmacy pharmacy) async {
    state = const AsyncValue.loading();
    try {
      await repository.addPharmacy(pharmacy);
      await loadPharmacies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePharmacy(String id, Pharmacy pharmacy) async {
    state = const AsyncValue.loading();
    try {
      await repository.updatePharmacy(id, pharmacy.toJson());
      await loadPharmacies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePharmacy(String id) async {
    state = const AsyncValue.loading();
    try {
      await repository.deletePharmacy(id);
      await loadPharmacies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final pharmacyProvider =
    StateNotifierProvider<PharmacyNotifier, AsyncValue<List<Pharmacy>>>((ref) {
  final repository = ref.watch(pharmacyRepositoryProvider);
  return PharmacyNotifier(repository);
});
