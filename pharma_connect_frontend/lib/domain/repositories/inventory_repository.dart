import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';

abstract class InventoryRepository {
  Future<InventoryItem> addInventoryItem(
      String pharmacyId, Map<String, dynamic> data);
  Future<List<InventoryItem>> getInventory(String pharmacyId);
  Future<InventoryItem> getInventoryItem(String pharmacyId, String inventoryId);
  Future<InventoryItem> updateInventoryItem(
      String pharmacyId, String inventoryId, Map<String, dynamic> data);
  Future<void> deleteInventoryItem(String pharmacyId, String inventoryId);
}
