import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/inventory_repository_impl.dart';

class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  final InventoryRepositoryImpl repository;
  final String pharmacyId;

  InventoryNotifier(this.repository, this.pharmacyId)
      : super(const AsyncValue.loading()) {
    loadInventory();
  }

  Future<void> loadInventory() async {
    state = const AsyncValue.loading();
    try {
      final items = await repository.getInventory(pharmacyId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addInventoryItem(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await repository.addInventoryItem(pharmacyId, data);
      await loadInventory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateInventoryItem(
      String inventoryId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateInventoryItem(pharmacyId, inventoryId, data);
      await loadInventory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteInventoryItem(String inventoryId) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteInventoryItem(pharmacyId, inventoryId);
      await loadInventory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final inventoryProvider = StateNotifierProvider.family<InventoryNotifier,
    AsyncValue<List<InventoryItem>>, String>((ref, pharmacyId) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return InventoryNotifier(repository, pharmacyId);
});
