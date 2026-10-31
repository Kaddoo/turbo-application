// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverCreateCWProxy {
  DriverCreate fullName(String fullName);

  DriverCreate phone(String phone);

  DriverCreate email(String? email);

  DriverCreate vehicleId(String? vehicleId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverCreate call({
    String fullName,
    String phone,
    String? email,
    String? vehicleId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverCreate.copyWith.fieldName(...)`
class _$DriverCreateCWProxyImpl implements _$DriverCreateCWProxy {
  const _$DriverCreateCWProxyImpl(this._value);

  final DriverCreate _value;

  @override
  DriverCreate fullName(String fullName) => this(fullName: fullName);

  @override
  DriverCreate phone(String phone) => this(phone: phone);

  @override
  DriverCreate email(String? email) => this(email: email);

  @override
  DriverCreate vehicleId(String? vehicleId) => this(vehicleId: vehicleId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverCreate call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? vehicleId = const $CopyWithPlaceholder(),
  }) {
    return DriverCreate(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      vehicleId: vehicleId == const $CopyWithPlaceholder()
          ? _value.vehicleId
          // ignore: cast_nullable_to_non_nullable
          : vehicleId as String?,
    );
  }
}

extension $DriverCreateCopyWith on DriverCreate {
  /// Returns a callable class that can be used as follows: `instanceOfDriverCreate.copyWith(...)` or like so:`instanceOfDriverCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverCreateCWProxy get copyWith => _$DriverCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverCreate _$DriverCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['fullName', 'phone']);
      final val = DriverCreate(
        fullName: $checkedConvert('fullName', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String?),
        vehicleId: $checkedConvert('vehicleId', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DriverCreateToJson(DriverCreate instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': ?instance.email,
      'vehicleId': ?instance.vehicleId,
    };
