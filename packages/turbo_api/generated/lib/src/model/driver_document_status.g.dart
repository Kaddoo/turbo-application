// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_document_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDocumentStatusCWProxy {
  DriverDocumentStatus type(DriverDocumentKind type);

  DriverDocumentStatus expiresOn(DateTime? expiresOn);

  DriverDocumentStatus daysLeft(int? daysLeft);

  DriverDocumentStatus status(DriverDocumentStatusStatusEnum status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentStatus(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentStatus call({
    DriverDocumentKind type,
    DateTime? expiresOn,
    int? daysLeft,
    DriverDocumentStatusStatusEnum status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDocumentStatus.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDocumentStatus.copyWith.fieldName(...)`
class _$DriverDocumentStatusCWProxyImpl
    implements _$DriverDocumentStatusCWProxy {
  const _$DriverDocumentStatusCWProxyImpl(this._value);

  final DriverDocumentStatus _value;

  @override
  DriverDocumentStatus type(DriverDocumentKind type) => this(type: type);

  @override
  DriverDocumentStatus expiresOn(DateTime? expiresOn) =>
      this(expiresOn: expiresOn);

  @override
  DriverDocumentStatus daysLeft(int? daysLeft) => this(daysLeft: daysLeft);

  @override
  DriverDocumentStatus status(DriverDocumentStatusStatusEnum status) =>
      this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentStatus(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentStatus call({
    Object? type = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
    Object? daysLeft = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return DriverDocumentStatus(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DriverDocumentKind,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime?,
      daysLeft: daysLeft == const $CopyWithPlaceholder()
          ? _value.daysLeft
          // ignore: cast_nullable_to_non_nullable
          : daysLeft as int?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DriverDocumentStatusStatusEnum,
    );
  }
}

extension $DriverDocumentStatusCopyWith on DriverDocumentStatus {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDocumentStatus.copyWith(...)` or like so:`instanceOfDriverDocumentStatus.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDocumentStatusCWProxy get copyWith =>
      _$DriverDocumentStatusCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDocumentStatus _$DriverDocumentStatusFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DriverDocumentStatus', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'status']);
  final val = DriverDocumentStatus(
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$DriverDocumentKindEnumMap, v),
    ),
    expiresOn: $checkedConvert(
      'expiresOn',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    daysLeft: $checkedConvert('daysLeft', (v) => (v as num?)?.toInt()),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$DriverDocumentStatusStatusEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$DriverDocumentStatusToJson(
  DriverDocumentStatus instance,
) => <String, dynamic>{
  'type': _$DriverDocumentKindEnumMap[instance.type]!,
  'expiresOn': ?instance.expiresOn?.toIso8601String(),
  'daysLeft': ?instance.daysLeft,
  'status': _$DriverDocumentStatusStatusEnumEnumMap[instance.status]!,
};

const _$DriverDocumentKindEnumMap = {
  DriverDocumentKind.driversLicence: 'drivers_licence',
  DriverDocumentKind.vehicleRegistration: 'vehicle_registration',
  DriverDocumentKind.insurance: 'insurance',
  DriverDocumentKind.roadworthy: 'roadworthy',
};

const _$DriverDocumentStatusStatusEnumEnumMap = {
  DriverDocumentStatusStatusEnum.valid: 'valid',
  DriverDocumentStatusStatusEnum.expiring: 'expiring',
  DriverDocumentStatusStatusEnum.expired: 'expired',
};
