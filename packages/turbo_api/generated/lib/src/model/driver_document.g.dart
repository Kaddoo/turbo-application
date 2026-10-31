// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_document.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDocumentCWProxy {
  DriverDocument id(String id);

  DriverDocument type(DriverDocumentTypeEnum type);

  DriverDocument expiresOn(DateTime? expiresOn);

  DriverDocument uploadId(String uploadId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocument(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocument(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocument call({
    String id,
    DriverDocumentTypeEnum type,
    DateTime? expiresOn,
    String uploadId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDocument.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDocument.copyWith.fieldName(...)`
class _$DriverDocumentCWProxyImpl implements _$DriverDocumentCWProxy {
  const _$DriverDocumentCWProxyImpl(this._value);

  final DriverDocument _value;

  @override
  DriverDocument id(String id) => this(id: id);

  @override
  DriverDocument type(DriverDocumentTypeEnum type) => this(type: type);

  @override
  DriverDocument expiresOn(DateTime? expiresOn) => this(expiresOn: expiresOn);

  @override
  DriverDocument uploadId(String uploadId) => this(uploadId: uploadId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDocument(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDocument(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDocument call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
    Object? uploadId = const $CopyWithPlaceholder(),
  }) {
    return DriverDocument(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DriverDocumentTypeEnum,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime?,
      uploadId: uploadId == const $CopyWithPlaceholder()
          ? _value.uploadId
          // ignore: cast_nullable_to_non_nullable
          : uploadId as String,
    );
  }
}

extension $DriverDocumentCopyWith on DriverDocument {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDocument.copyWith(...)` or like so:`instanceOfDriverDocument.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDocumentCWProxy get copyWith => _$DriverDocumentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDocument _$DriverDocumentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverDocument', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'type', 'uploadId']);
      final val = DriverDocument(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$DriverDocumentTypeEnumEnumMap, v),
        ),
        expiresOn: $checkedConvert(
          'expiresOn',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        uploadId: $checkedConvert('uploadId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DriverDocumentToJson(DriverDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$DriverDocumentTypeEnumEnumMap[instance.type]!,
      'expiresOn': ?instance.expiresOn?.toIso8601String(),
      'uploadId': instance.uploadId,
    };

const _$DriverDocumentTypeEnumEnumMap = {
  DriverDocumentTypeEnum.driversLicence: 'drivers_licence',
  DriverDocumentTypeEnum.ghanaCard: 'ghana_card',
  DriverDocumentTypeEnum.vehicleRegistration: 'vehicle_registration',
  DriverDocumentTypeEnum.insurance: 'insurance',
  DriverDocumentTypeEnum.roadworthy: 'roadworthy',
  DriverDocumentTypeEnum.other: 'other',
};
