// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_slot.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadSlotCWProxy {
  UploadSlot uploadId(String uploadId);

  UploadSlot uploadUrl(String uploadUrl);

  UploadSlot method(UploadSlotMethodEnum method);

  UploadSlot headers(Map<String, String>? headers);

  UploadSlot expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadSlot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadSlot call({
    String uploadId,
    String uploadUrl,
    UploadSlotMethodEnum method,
    Map<String, String>? headers,
    DateTime expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadSlot.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadSlot.copyWith.fieldName(...)`
class _$UploadSlotCWProxyImpl implements _$UploadSlotCWProxy {
  const _$UploadSlotCWProxyImpl(this._value);

  final UploadSlot _value;

  @override
  UploadSlot uploadId(String uploadId) => this(uploadId: uploadId);

  @override
  UploadSlot uploadUrl(String uploadUrl) => this(uploadUrl: uploadUrl);

  @override
  UploadSlot method(UploadSlotMethodEnum method) => this(method: method);

  @override
  UploadSlot headers(Map<String, String>? headers) => this(headers: headers);

  @override
  UploadSlot expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadSlot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadSlot(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadSlot call({
    Object? uploadId = const $CopyWithPlaceholder(),
    Object? uploadUrl = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? headers = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return UploadSlot(
      uploadId: uploadId == const $CopyWithPlaceholder()
          ? _value.uploadId
          // ignore: cast_nullable_to_non_nullable
          : uploadId as String,
      uploadUrl: uploadUrl == const $CopyWithPlaceholder()
          ? _value.uploadUrl
          // ignore: cast_nullable_to_non_nullable
          : uploadUrl as String,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as UploadSlotMethodEnum,
      headers: headers == const $CopyWithPlaceholder()
          ? _value.headers
          // ignore: cast_nullable_to_non_nullable
          : headers as Map<String, String>?,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $UploadSlotCopyWith on UploadSlot {
  /// Returns a callable class that can be used as follows: `instanceOfUploadSlot.copyWith(...)` or like so:`instanceOfUploadSlot.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadSlotCWProxy get copyWith => _$UploadSlotCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadSlot _$UploadSlotFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UploadSlot', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['uploadId', 'uploadUrl', 'method', 'expiresAt'],
  );
  final val = UploadSlot(
    uploadId: $checkedConvert('uploadId', (v) => v as String),
    uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
    method: $checkedConvert(
      'method',
      (v) => $enumDecode(_$UploadSlotMethodEnumEnumMap, v),
    ),
    headers: $checkedConvert(
      'headers',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)),
    ),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$UploadSlotToJson(UploadSlot instance) =>
    <String, dynamic>{
      'uploadId': instance.uploadId,
      'uploadUrl': instance.uploadUrl,
      'method': _$UploadSlotMethodEnumEnumMap[instance.method]!,
      'headers': ?instance.headers,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

const _$UploadSlotMethodEnumEnumMap = {UploadSlotMethodEnum.PUT: 'PUT'};
