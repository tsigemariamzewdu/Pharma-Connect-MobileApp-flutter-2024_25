import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String pharmacyName,
    required String inventoryId,
    required String address,
    required String photo,
    required double price,
    required int quantity,
    required double latitude,
    required double longitude,
    required String pharmacyId,
    required String medicineId,
    required String medicineName,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
