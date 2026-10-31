// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_complete_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCompleteRequestCWProxy {
  AdminCompleteRequest reasonCode(
    AdminCompleteRequestReasonCodeEnum reasonCode,
  );

  AdminCompleteRequest note(String note);

  AdminCompleteRequest completionPoint(GeoPoint? completionPoint);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCompleteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCompleteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCompleteRequest call({
    AdminCompleteRequestReasonCodeEnum reasonCode,
    String note,
    GeoPoint? completionPoint,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCompleteRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCompleteRequest.copyWith.fieldName(...)`
class _$AdminCompleteRequestCWProxyImpl
    implements _$AdminCompleteRequestCWProxy {
  const _$AdminCompleteRequestCWProxyImpl(this._value);

  final AdminCompleteRequest _value;

  @override
  AdminCompleteRequest reasonCode(
    AdminCompleteRequestReasonCodeEnum reasonCode,
  ) => this(reasonCode: reasonCode);

  @override
  AdminCompleteRequest note(String note) => this(note: note);

  @override
  AdminCompleteRequest completionPoint(GeoPoint? completionPoint) =>
      this(completionPoint: completionPoint);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCompleteRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCompleteRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCompleteRequest call({
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? completionPoint = const $CopyWithPlaceholder(),
  }) {
    return AdminCompleteRequest(
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as AdminCompleteRequestReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
      completionPoint: completionPoint == const $CopyWithPlaceholder()
          ? _value.completionPoint
          // ignore: cast_nullable_to_non_nullable
          : completionPoint as GeoPoint?,
    );
  }
}

extension $AdminCompleteRequestCopyWith on AdminCompleteRequest {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCompleteRequest.copyWith(...)` or like so:`instanceOfAdminCompleteRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCompleteRequestCWProxy get copyWith =>
      _$AdminCompleteRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCompleteRequest _$AdminCompleteRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminCompleteRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['reasonCode', 'note']);
  final val = AdminCompleteRequest(
    reasonCode: $checkedConvert(
      'reasonCode',
      (v) => $enumDecode(_$AdminCompleteRequestReasonCodeEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String),
    completionPoint: $checkedConvert(
      'completionPoint',
      (v) => v == null ? null : GeoPoint.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AdminCompleteRequestToJson(
  AdminCompleteRequest instance,
) => <String, dynamic>{
  'reasonCode':
      _$AdminCompleteRequestReasonCodeEnumEnumMap[instance.reasonCode]!,
  'note': instance.note,
  'completionPoint': ?instance.completionPoint?.toJson(),
};

const _$AdminCompleteRequestReasonCodeEnumEnumMap = {
  AdminCompleteRequestReasonCodeEnum.driverUnreachable: 'driver_unreachable',
  AdminCompleteRequestReasonCodeEnum.appFailure: 'app_failure',
  AdminCompleteRequestReasonCodeEnum.driverForgot: 'driver_forgot',
  AdminCompleteRequestReasonCodeEnum.other: 'other',
};
