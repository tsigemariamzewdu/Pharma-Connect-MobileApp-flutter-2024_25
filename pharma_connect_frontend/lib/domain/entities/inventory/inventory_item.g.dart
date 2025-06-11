// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['_id'] as String,
      medicineId: json['medicine'] as String,
      medicineName: json['medicineName'] as String,
      pharmacyId: json['pharmacy'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      status: json['status'] as String? ?? 'active',
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'medicine': instance.medicineId,
      'medicineName': instance.medicineName,
      'pharmacy': instance.pharmacyId,
      'price': instance.price,
      'quantity': instance.quantity,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'status': instance.status,
      'category': instance.category,
    };
