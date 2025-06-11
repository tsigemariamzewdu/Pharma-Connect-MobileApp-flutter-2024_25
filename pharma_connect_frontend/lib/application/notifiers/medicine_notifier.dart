import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/medicine_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';

class MedicineNotifier extends StateNotifier<AsyncValue<List<Medicine>>> {
  final MedicineRepositoryImpl repository;

  MedicineNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    state = const AsyncValue.loading();
    final result = await repository.getMedicines();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (medicines) => state = AsyncValue.data(medicines),
    );
  }

  Future<void> addMedicine(Medicine medicine) async {
    state = const AsyncValue.loading();
    final result = await repository.addMedicine(medicine);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadMedicines(),
    );
  }

  Future<void> updateMedicine(Medicine medicine) async {
    state = const AsyncValue.loading();
    final result = await repository.updateMedicine(medicine);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadMedicines(),
    );
  }

  Future<void> deleteMedicine(String id) async {
    state = const AsyncValue.loading();
    final result = await repository.deleteMedicine(id);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadMedicines(),
    );
  }
}

final medicineProvider =
    StateNotifierProvider<MedicineNotifier, AsyncValue<List<Medicine>>>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return MedicineNotifier(repository);
});

class MedicineSearchNotifier
    extends StateNotifier<AsyncValue<List<MedicineSearchResult>>> {
  final MedicineRepositoryImpl repository;
  MedicineSearchNotifier(this.repository) : super(const AsyncValue.data([]));

  Future<void> searchMedicines(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    final result = await repository.searchPharmacyInventory(query);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (results) => state = AsyncValue.data(results),
    );
  }
}

final medicineSearchProvider = StateNotifierProvider<MedicineSearchNotifier,
    AsyncValue<List<MedicineSearchResult>>>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return MedicineSearchNotifier(repository);
});
