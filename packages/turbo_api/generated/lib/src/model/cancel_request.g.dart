// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancelRequestCWProxy {
  CancelRequest reasonCode(CancelRequestReasonCodeEnum? reasonCode);

  CancelRequest note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelRequest call({CancelRequestReasonCodeEnum? reasonCode, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancelRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancelRequest.copyWith.fieldName(...)`
class _$CancelRequestCWProxyImpl implements _$CancelRequestCWProxy {
  const _$CancelRequestCWProxyImpl(this._value);

  final CancelRequest _value;

  @override
  CancelRequest reasonCode(CancelRequestReasonCodeEnum? reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  CancelRequest note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelRequest call({
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return CancelRequest(
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as CancelRequestReasonCodeEnum?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $CancelRequestCopyWith on CancelRequest {
  /// Returns a callable class that can be used as follows: `instanceOfCancelRequest.copyWith(...)` or like so:`instanceOfCancelRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancelRequestCWProxy get copyWith => _$CancelRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelRequest _$CancelRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CancelRequest', json, ($checkedConvert) {
      final val = CancelRequest(
        reasonCode: $checkedConvert(
          'reasonCode',
          (v) => $enumDecodeNullable(_$CancelRequestReasonCodeEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CancelRequestToJson(CancelRequest instance) =>
    <String, dynamic>{
      'reasonCode': ?_$CancelRequestReasonCodeEnumEnumMap[instance.reasonCode],
      'note': ?instance.note,
    };

const _$CancelRequestReasonCodeEnumEnumMap = {
  CancelRequestReasonCodeEnum.studentChangedMind: 'student_changed_mind',
  CancelRequestReasonCodeEnum.waitTooLong: 'wait_too_long',
  CancelRequestReasonCodeEnum.wrongLocation: 'wrong_location',
  CancelRequestReasonCodeEnum.other: 'other',
};
