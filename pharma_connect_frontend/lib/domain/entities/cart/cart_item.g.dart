// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      pharmacyName: json['pharmacyName'] as String,
      inventoryId: json['inventoryId'] as String,
      address: json['address'] as String,
      photo: json['photo'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pharmacyId: json['pharmacyId'] as String,
      medicineId: json['medicineId'] as String,
      medicineName: json['medicineName'] as String,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'pharmacyName': instance.pharmacyName,
      'inventoryId': instance.inventoryId,
      'address': instance.address,
      'photo': instance.photo,
      'price': instance.price,
      'quantity': instance.quantity,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pharmacyId': instance.pharmacyId,
      'medicineId': instance.medicineId,
      'medicineName': instance.medicineName,
    };
