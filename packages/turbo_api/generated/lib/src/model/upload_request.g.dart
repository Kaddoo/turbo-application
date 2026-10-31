// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadRequestCWProxy {
  UploadRequest purpose(UploadRequestPurposeEnum purpose);

  UploadRequest contentType(UploadRequestContentTypeEnum contentType);

  UploadRequest sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadRequest call({
    UploadRequestPurposeEnum purpose,
    UploadRequestContentTypeEnum contentType,
    int sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadRequest.copyWith.fieldName(...)`
class _$UploadRequestCWProxyImpl implements _$UploadRequestCWProxy {
  const _$UploadRequestCWProxyImpl(this._value);

  final UploadRequest _value;

  @override
  UploadRequest purpose(UploadRequestPurposeEnum purpose) =>
      this(purpose: purpose);

  @override
  UploadRequest contentType(UploadRequestContentTypeEnum contentType) =>
      this(contentType: contentType);

  @override
  UploadRequest sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadRequest call({
    Object? purpose = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return UploadRequest(
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as UploadRequestPurposeEnum,
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as UploadRequestContentTypeEnum,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as int,
    );
  }
}

extension $UploadRequestCopyWith on UploadRequest {
  /// Returns a callable class that can be used as follows: `instanceOfUploadRequest.copyWith(...)` or like so:`instanceOfUploadRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadRequestCWProxy get copyWith => _$UploadRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadRequest _$UploadRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadRequest', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['purpose', 'contentType', 'sizeBytes'],
      );
      final val = UploadRequest(
        purpose: $checkedConvert(
          'purpose',
          (v) => $enumDecode(_$UploadRequestPurposeEnumEnumMap, v),
        ),
        contentType: $checkedConvert(
          'contentType',
          (v) => $enumDecode(_$UploadRequestContentTypeEnumEnumMap, v),
        ),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$UploadRequestToJson(
  UploadRequest instance,
) => <String, dynamic>{
  'purpose': _$UploadRequestPurposeEnumEnumMap[instance.purpose]!,
  'contentType': _$UploadRequestContentTypeEnumEnumMap[instance.contentType]!,
  'sizeBytes': instance.sizeBytes,
};

const _$UploadRequestPurposeEnumEnumMap = {
  UploadRequestPurposeEnum.ghanaCardFront: 'ghana_card_front',
  UploadRequestPurposeEnum.ghanaCardBack: 'ghana_card_back',
  UploadRequestPurposeEnum.studentId: 'student_id',
  UploadRequestPurposeEnum.driverDocument: 'driver_document',
  UploadRequestPurposeEnum.vehicleDocument: 'vehicle_document',
  UploadRequestPurposeEnum.supportAttachment: 'support_attachment',
  UploadRequestPurposeEnum.selfieWithCard: 'selfie_with_card',
  UploadRequestPurposeEnum.providerStatement: 'provider_statement',
};

const _$UploadRequestContentTypeEnumEnumMap = {
  UploadRequestContentTypeEnum.imageSlashJpeg: 'image/jpeg',
  UploadRequestContentTypeEnum.imageSlashPng: 'image/png',
  UploadRequestContentTypeEnum.applicationSlashPdf: 'application/pdf',
};
