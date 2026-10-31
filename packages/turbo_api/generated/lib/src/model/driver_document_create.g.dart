// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_document_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDocumentCreateCWProxy {
  DriverDocumentCreate type(DriverDocumentCreateTypeEnum type);

  DriverDocumentCreate uploadId(String uploadId);

  DriverDocumentCreate expiresOn(DateTime? expiresOn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentCreate call({
    DriverDocumentCreateTypeEnum type,
    String uploadId,
    DateTime? expiresOn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDocumentCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDocumentCreate.copyWith.fieldName(...)`
class _$DriverDocumentCreateCWProxyImpl
    implements _$DriverDocumentCreateCWProxy {
  const _$DriverDocumentCreateCWProxyImpl(this._value);

  final DriverDocumentCreate _value;

  @override
  DriverDocumentCreate type(DriverDocumentCreateTypeEnum type) =>
      this(type: type);

  @override
  DriverDocumentCreate uploadId(String uploadId) => this(uploadId: uploadId);

  @override
  DriverDocumentCreate expiresOn(DateTime? expiresOn) =>
      this(expiresOn: expiresOn);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocumentCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocumentCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocumentCreate call({
    Object? type = const $CopyWithPlaceholder(),
    Object? uploadId = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
  }) {
    return DriverDocumentCreate(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DriverDocumentCreateTypeEnum,
      uploadId: uploadId == const $CopyWithPlaceholder()
          ? _value.uploadId
          // ignore: cast_nullable_to_non_nullable
          : uploadId as String,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime?,
    );
  }
}

extension $DriverDocumentCreateCopyWith on DriverDocumentCreate {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDocumentCreate.copyWith(...)` or like so:`instanceOfDriverDocumentCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDocumentCreateCWProxy get copyWith =>
      _$DriverDocumentCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDocumentCreate _$DriverDocumentCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DriverDocumentCreate', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'uploadId']);
  final val = DriverDocumentCreate(
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$DriverDocumentCreateTypeEnumEnumMap, v),
    ),
    uploadId: $checkedConvert('uploadId', (v) => v as String),
    expiresOn: $checkedConvert(
      'expiresOn',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$DriverDocumentCreateToJson(
  DriverDocumentCreate instance,
) => <String, dynamic>{
  'type': _$DriverDocumentCreateTypeEnumEnumMap[instance.type]!,
  'uploadId': instance.uploadId,
  'expiresOn': ?instance.expiresOn?.toIso8601String(),
};

const _$DriverDocumentCreateTypeEnumEnumMap = {
  DriverDocumentCreateTypeEnum.driversLicence: 'drivers_licence',
  DriverDocumentCreateTypeEnum.ghanaCard: 'ghana_card',
  DriverDocumentCreateTypeEnum.vehicleRegistration: 'vehicle_registration',
  DriverDocumentCreateTypeEnum.insurance: 'insurance',
  DriverDocumentCreateTypeEnum.roadworthy: 'roadworthy',
  DriverDocumentCreateTypeEnum.other: 'other',
};
