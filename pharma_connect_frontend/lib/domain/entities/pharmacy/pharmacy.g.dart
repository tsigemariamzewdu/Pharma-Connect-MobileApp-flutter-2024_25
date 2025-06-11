// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PharmacyImpl _$$PharmacyImplFromJson(Map<String, dynamic> json) =>
    _$PharmacyImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      ownerName: json['ownerName'] as String,
      ownerId: json['ownerId'] as String,
      licenseNumber: json['licenseNumber'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      licenseImage: json['licenseImage'] as String?,
      pharmacyImage: json['pharmacyImage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      pharmacists: (json['pharmacists'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PharmacyImplToJson(_$PharmacyImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'ownerName': instance.ownerName,
      'ownerId': instance.ownerId,
      'licenseNumber': instance.licenseNumber,
      'email': instance.email,
      'contactNumber': instance.contactNumber,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'licenseImage': instance.licenseImage,
      'pharmacyImage': instance.pharmacyImage,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'pharmacists': instance.pharmacists,
    };
