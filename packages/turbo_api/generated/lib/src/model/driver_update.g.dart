// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverUpdateCWProxy {
  DriverUpdate fullName(String? fullName);

  DriverUpdate status(AccountStatus? status);

  DriverUpdate vehicleId(String? vehicleId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverUpdate call({
    String? fullName,
    AccountStatus? status,
    String? vehicleId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverUpdate.copyWith.fieldName(...)`
class _$DriverUpdateCWProxyImpl implements _$DriverUpdateCWProxy {
  const _$DriverUpdateCWProxyImpl(this._value);

  final DriverUpdate _value;

  @override
  DriverUpdate fullName(String? fullName) => this(fullName: fullName);

  @override
  DriverUpdate status(AccountStatus? status) => this(status: status);

  @override
  DriverUpdate vehicleId(String? vehicleId) => this(vehicleId: vehicleId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverUpdate call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? vehicleId = const $CopyWithPlaceholder(),
  }) {
    return DriverUpdate(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AccountStatus?,
      vehicleId: vehicleId == const $CopyWithPlaceholder()
          ? _value.vehicleId
          // ignore: cast_nullable_to_non_nullable
          : vehicleId as String?,
    );
  }
}

extension $DriverUpdateCopyWith on DriverUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfDriverUpdate.copyWith(...)` or like so:`instanceOfDriverUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverUpdateCWProxy get copyWith => _$DriverUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverUpdate _$DriverUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverUpdate', json, ($checkedConvert) {
      final val = DriverUpdate(
        fullName: $checkedConvert('fullName', (v) => v as String?),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$AccountStatusEnumMap, v),
        ),
        vehicleId: $checkedConvert('vehicleId', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DriverUpdateToJson(DriverUpdate instance) =>
    <String, dynamic>{
      'fullName': ?instance.fullName,
      'status': ?_$AccountStatusEnumMap[instance.status],
      'vehicleId': ?instance.vehicleId,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
};
