// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharmacy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) {
  return _Pharmacy.fromJson(json);
}

/// @nodoc
mixin _$Pharmacy {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ownerId')
  String get ownerId => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get contactNumber => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'zipCode')
  String get zipCode => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'licenseImage')
  String? get licenseImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'pharmacyImage')
  String? get pharmacyImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String> get pharmacists => throw _privateConstructorUsedError;

  /// Serializes this Pharmacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PharmacyCopyWith<Pharmacy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PharmacyCopyWith<$Res> {
  factory $PharmacyCopyWith(Pharmacy value, $Res Function(Pharmacy) then) =
      _$PharmacyCopyWithImpl<$Res, Pharmacy>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String ownerName,
      @JsonKey(name: 'ownerId') String ownerId,
      String licenseNumber,
      String email,
      String contactNumber,
      String address,
      String city,
      String state,
      @JsonKey(name: 'zipCode') String zipCode,
      double latitude,
      double longitude,
      @JsonKey(name: 'licenseImage') String? licenseImage,
      @JsonKey(name: 'pharmacyImage') String? pharmacyImage,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      List<String> pharmacists});
}

/// @nodoc
class _$PharmacyCopyWithImpl<$Res, $Val extends Pharmacy>
    implements $PharmacyCopyWith<$Res> {
  _$PharmacyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerName = null,
    Object? ownerId = null,
    Object? licenseNumber = null,
    Object? email = null,
    Object? contactNumber = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? licenseImage = freezed,
    Object? pharmacyImage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? pharmacists = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      contactNumber: null == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      licenseImage: freezed == licenseImage
          ? _value.licenseImage
          : licenseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      pharmacyImage: freezed == pharmacyImage
          ? _value.pharmacyImage
          : pharmacyImage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pharmacists: null == pharmacists
          ? _value.pharmacists
          : pharmacists // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PharmacyImplCopyWith<$Res>
    implements $PharmacyCopyWith<$Res> {
  factory _$$PharmacyImplCopyWith(
          _$PharmacyImpl value, $Res Function(_$PharmacyImpl) then) =
      __$$PharmacyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String ownerName,
      @JsonKey(name: 'ownerId') String ownerId,
      String licenseNumber,
      String email,
      String contactNumber,
      String address,
      String city,
      String state,
      @JsonKey(name: 'zipCode') String zipCode,
      double latitude,
      double longitude,
      @JsonKey(name: 'licenseImage') String? licenseImage,
      @JsonKey(name: 'pharmacyImage') String? pharmacyImage,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      List<String> pharmacists});
}

/// @nodoc
class __$$PharmacyImplCopyWithImpl<$Res>
    extends _$PharmacyCopyWithImpl<$Res, _$PharmacyImpl>
    implements _$$PharmacyImplCopyWith<$Res> {
  __$$PharmacyImplCopyWithImpl(
      _$PharmacyImpl _value, $Res Function(_$PharmacyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerName = null,
    Object? ownerId = null,
    Object? licenseNumber = null,
    Object? email = null,
    Object? contactNumber = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? licenseImage = freezed,
    Object? pharmacyImage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? pharmacists = null,
  }) {
    return _then(_$PharmacyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      contactNumber: null == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      licenseImage: freezed == licenseImage
          ? _value.licenseImage
          : licenseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      pharmacyImage: freezed == pharmacyImage
          ? _value.pharmacyImage
          : pharmacyImage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pharmacists: null == pharmacists
          ? _value._pharmacists
          : pharmacists // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PharmacyImpl implements _Pharmacy {
  const _$PharmacyImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.name,
      required this.ownerName,
      @JsonKey(name: 'ownerId') required this.ownerId,
      required this.licenseNumber,
      required this.email,
      required this.contactNumber,
      required this.address,
      required this.city,
      required this.state,
      @JsonKey(name: 'zipCode') required this.zipCode,
      required this.latitude,
      required this.longitude,
      @JsonKey(name: 'licenseImage') this.licenseImage,
      @JsonKey(name: 'pharmacyImage') this.pharmacyImage,
      @JsonKey(name: 'createdAt') this.createdAt,
      @JsonKey(name: 'updatedAt') this.updatedAt,
      final List<String> pharmacists = const []})
      : _pharmacists = pharmacists;

  factory _$PharmacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PharmacyImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String ownerName;
  @override
  @JsonKey(name: 'ownerId')
  final String ownerId;
  @override
  final String licenseNumber;
  @override
  final String email;
  @override
  final String contactNumber;
  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  @JsonKey(name: 'zipCode')
  final String zipCode;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey(name: 'licenseImage')
  final String? licenseImage;
  @override
  @JsonKey(name: 'pharmacyImage')
  final String? pharmacyImage;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final List<String> _pharmacists;
  @override
  @JsonKey()
  List<String> get pharmacists {
    if (_pharmacists is EqualUnmodifiableListView) return _pharmacists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pharmacists);
  }

  @override
  String toString() {
    return 'Pharmacy(id: $id, name: $name, ownerName: $ownerName, ownerId: $ownerId, licenseNumber: $licenseNumber, email: $email, contactNumber: $contactNumber, address: $address, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, licenseImage: $licenseImage, pharmacyImage: $pharmacyImage, createdAt: $createdAt, updatedAt: $updatedAt, pharmacists: $pharmacists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PharmacyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.licenseImage, licenseImage) ||
                other.licenseImage == licenseImage) &&
            (identical(other.pharmacyImage, pharmacyImage) ||
                other.pharmacyImage == pharmacyImage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._pharmacists, _pharmacists));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      ownerName,
      ownerId,
      licenseNumber,
      email,
      contactNumber,
      address,
      city,
      state,
      zipCode,
      latitude,
      longitude,
      licenseImage,
      pharmacyImage,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_pharmacists));

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PharmacyImplCopyWith<_$PharmacyImpl> get copyWith =>
      __$$PharmacyImplCopyWithImpl<_$PharmacyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PharmacyImplToJson(
      this,
    );
  }
}

abstract class _Pharmacy implements Pharmacy {
  const factory _Pharmacy(
      {@JsonKey(name: '_id') required final String id,
      required final String name,
      required final String ownerName,
      @JsonKey(name: 'ownerId') required final String ownerId,
      required final String licenseNumber,
      required final String email,
      required final String contactNumber,
      required final String address,
      required final String city,
      required final String state,
      @JsonKey(name: 'zipCode') required final String zipCode,
      required final double latitude,
      required final double longitude,
      @JsonKey(name: 'licenseImage') final String? licenseImage,
      @JsonKey(name: 'pharmacyImage') final String? pharmacyImage,
      @JsonKey(name: 'createdAt') final DateTime? createdAt,
      @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
      final List<String> pharmacists}) = _$PharmacyImpl;

  factory _Pharmacy.fromJson(Map<String, dynamic> json) =
      _$PharmacyImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get ownerName;
  @override
  @JsonKey(name: 'ownerId')
  String get ownerId;
  @override
  String get licenseNumber;
  @override
  String get email;
  @override
  String get contactNumber;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(name: 'zipCode')
  String get zipCode;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(name: 'licenseImage')
  String? get licenseImage;
  @override
  @JsonKey(name: 'pharmacyImage')
  String? get pharmacyImage;
  @override
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override
  List<String> get pharmacists;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PharmacyImplCopyWith<_$PharmacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
