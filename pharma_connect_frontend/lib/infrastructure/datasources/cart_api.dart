import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';

class CartApi {
  final Dio client;

  CartApi(this.client);

  Future<List<CartItem>> getCartItems() async {
    final response = await client.get('/users/my-medicines');
    final data = response.data['data'] ?? [];
    return (data as List).map((json) => CartItem.fromJson(json)).toList();
  }

  Future<List<CartItem>> addItem(String inventoryId) async {
    await client.post('/users/addtocart', data: {'inventoryId': inventoryId});
    return getCartItems();
  }

  Future<List<CartItem>> removeItem(
      String pharmacyId, String medicineId) async {
    await client.delete('/users/my-medicines/',
        data: {'pharmacyId': pharmacyId, 'medicineId': medicineId});
    return getCartItems();
  }

  Future<List<CartItem>> clearCart() async {
    await client.delete('/users/my-medicines/deleteAll');
    return getCartItems();
  }
}
