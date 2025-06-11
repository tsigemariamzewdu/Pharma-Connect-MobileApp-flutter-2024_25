import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/core/constants.dart';
import 'package:pharma_connect_flutter/domain/entities/inventory/inventory_item.dart';

class InventoryApi {
  final Dio dio;
  final String baseUrl;

  InventoryApi({required this.dio, this.baseUrl = '/pharmacies'});

  Future<InventoryItem> addInventoryItem(
      String pharmacyId, Map<String, dynamic> data) async {
    final response =
        await dio.post('$baseUrl/$pharmacyId/inventory', data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return InventoryItem.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to add inventory item');
    }
  }

  Future<List<InventoryItem>> getInventory(String pharmacyId) async {
    final response = await dio.get('$baseUrl/$pharmacyId/inventory');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load inventory');
    }
  }

  Future<InventoryItem> getInventoryItem(
      String pharmacyId, String inventoryId) async {
    final response =
        await dio.get('$baseUrl/$pharmacyId/inventory/$inventoryId');
    if (response.statusCode == 200) {
      return InventoryItem.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load inventory item');
    }
  }

  Future<InventoryItem> updateInventoryItem(
      String pharmacyId, String inventoryId, Map<String, dynamic> data) async {
    final response = await dio
        .patch('$baseUrl/$pharmacyId/inventory/$inventoryId', data: data);
    if (response.statusCode == 200) {
      return InventoryItem.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update inventory item');
    }
  }

  Future<void> deleteInventoryItem(
      String pharmacyId, String inventoryId) async {
    final response =
        await dio.delete('$baseUrl/$pharmacyId/inventory/$inventoryId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete inventory item');
    }
  }
}
