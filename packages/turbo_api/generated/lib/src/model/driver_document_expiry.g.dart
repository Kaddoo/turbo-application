// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_document_expiry.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDocumentExpiryCWProxy {
  DriverDocumentExpiry driverId(String driverId);

  DriverDocumentExpiry driverName(String driverName);

  DriverDocumentExpiry documentType(String documentType);

  DriverDocumentExpiry expiresOn(DateTime expiresOn);

  DriverDocumentExpiry daysLeft(int daysLeft);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentExpiry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentExpiry(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentExpiry call({
    String driverId,
    String driverName,
    String documentType,
    DateTime expiresOn,
    int daysLeft,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDocumentExpiry.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDocumentExpiry.copyWith.fieldName(...)`
class _$DriverDocumentExpiryCWProxyImpl
    implements _$DriverDocumentExpiryCWProxy {
  const _$DriverDocumentExpiryCWProxyImpl(this._value);

  final DriverDocumentExpiry _value;

  @override
  DriverDocumentExpiry driverId(String driverId) => this(driverId: driverId);

  @override
  DriverDocumentExpiry driverName(String driverName) =>
      this(driverName: driverName);

  @override
  DriverDocumentExpiry documentType(String documentType) =>
      this(documentType: documentType);

  @override
  DriverDocumentExpiry expiresOn(DateTime expiresOn) =>
      this(expiresOn: expiresOn);

  @override
  DriverDocumentExpiry daysLeft(int daysLeft) => this(daysLeft: daysLeft);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentExpiry(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentExpiry(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentExpiry call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? driverName = const $CopyWithPlaceholder(),
    Object? documentType = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
    Object? daysLeft = const $CopyWithPlaceholder(),
  }) {
    return DriverDocumentExpiry(
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      driverName: driverName == const $CopyWithPlaceholder()
          ? _value.driverName
          // ignore: cast_nullable_to_non_nullable
          : driverName as String,
      documentType: documentType == const $CopyWithPlaceholder()
          ? _value.documentType
          // ignore: cast_nullable_to_non_nullable
          : documentType as String,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime,
      daysLeft: daysLeft == const $CopyWithPlaceholder()
          ? _value.daysLeft
          // ignore: cast_nullable_to_non_nullable
          : daysLeft as int,
    );
  }
}

extension $DriverDocumentExpiryCopyWith on DriverDocumentExpiry {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDocumentExpiry.copyWith(...)` or like so:`instanceOfDriverDocumentExpiry.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDocumentExpiryCWProxy get copyWith =>
      _$DriverDocumentExpiryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDocumentExpiry _$DriverDocumentExpiryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DriverDocumentExpiry', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'driverId',
      'driverName',
      'documentType',
      'expiresOn',
      'daysLeft',
    ],
  );
  final val = DriverDocumentExpiry(
    driverId: $checkedConvert('driverId', (v) => v as String),
    driverName: $checkedConvert('driverName', (v) => v as String),
    documentType: $checkedConvert('documentType', (v) => v as String),
    expiresOn: $checkedConvert('expiresOn', (v) => DateTime.parse(v as String)),
    daysLeft: $checkedConvert('daysLeft', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$DriverDocumentExpiryToJson(
  DriverDocumentExpiry instance,
) => <String, dynamic>{
  'driverId': instance.driverId,
  'driverName': instance.driverName,
  'documentType': instance.documentType,
  'expiresOn': instance.expiresOn.toIso8601String(),
  'daysLeft': instance.daysLeft,
};
