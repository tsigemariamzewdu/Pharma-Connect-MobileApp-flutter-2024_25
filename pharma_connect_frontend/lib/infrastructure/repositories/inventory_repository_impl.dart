import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';
import 'package:pharma_connect_flutter/domain/repositories/inventory_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/inventory_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryApi inventoryApi;

  InventoryRepositoryImpl({required this.inventoryApi});

  @override
  Future<InventoryItem> addInventoryItem(
      String pharmacyId, Map<String, dynamic> data) async {
    return await inventoryApi.addInventoryItem(pharmacyId, data);
  }

  @override
  Future<List<InventoryItem>> getInventory(String pharmacyId) async {
    return await inventoryApi.getInventory(pharmacyId);
  }

  @override
  Future<InventoryItem> getInventoryItem(
      String pharmacyId, String inventoryId) async {
    return await inventoryApi.getInventoryItem(pharmacyId, inventoryId);
  }

  @override
  Future<InventoryItem> updateInventoryItem(
      String pharmacyId, String inventoryId, Map<String, dynamic> data) async {
    return await inventoryApi.updateInventoryItem(
        pharmacyId, inventoryId, data);
  }

  @override
  Future<void> deleteInventoryItem(
      String pharmacyId, String inventoryId) async {
    await inventoryApi.deleteInventoryItem(pharmacyId, inventoryId);
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepositoryImpl>((ref) {
  final api = ref.watch(inventoryApiProvider);
  return InventoryRepositoryImpl(inventoryApi: api);
});
