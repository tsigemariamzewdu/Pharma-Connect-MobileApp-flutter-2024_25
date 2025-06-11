import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy.freezed.dart';
part 'pharmacy.g.dart';

@freezed
class Pharmacy with _$Pharmacy {
  const factory Pharmacy({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String ownerName,
    @JsonKey(name: 'ownerId') required String ownerId,
    required String licenseNumber,
    required String email,
    required String contactNumber,
    required String address,
    required String city,
    required String state,
    @JsonKey(name: 'zipCode') required String zipCode,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'licenseImage') String? licenseImage,
    @JsonKey(name: 'pharmacyImage') String? pharmacyImage,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @Default([]) List<String> pharmacists,
  }) = _Pharmacy;

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);
}
