import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';

void main() {
  test('CartItem value equality and fromJson/toJson', () {
    const cartItem1 = CartItem(
      pharmacyName: 'Pharma',
      inventoryId: 'inv1',
      address: '123 St',
      photo: 'img.png',
      price: 10.0,
      quantity: 2,
      latitude: 1.0,
      longitude: 2.0,
      pharmacyId: 'ph1',
      medicineId: 'med1',
      medicineName: 'Aspirin',
    );
    const cartItem2 = CartItem(
      pharmacyName: 'Pharma',
      inventoryId: 'inv1',
      address: '123 St',
      photo: 'img.png',
      price: 10.0,
      quantity: 2,
      latitude: 1.0,
      longitude: 2.0,
      pharmacyId: 'ph1',
      medicineId: 'med1',
      medicineName: 'Aspirin',
    );
    expect(cartItem1, cartItem2);
    final json = cartItem1.toJson();
    final fromJson = CartItem.fromJson(json);
    expect(fromJson, cartItem1);
  });
}
