import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

@freezed
class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'medicine') required String medicineId,
    required String medicineName,
    @JsonKey(name: 'pharmacy') required String pharmacyId,
    required double price,
    required int quantity,
    required DateTime expiryDate,
    @Default('active') String status,
    String? category,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}
