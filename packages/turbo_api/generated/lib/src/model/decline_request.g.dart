// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decline_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeclineRequestCWProxy {
  DeclineRequest reasonCode(DeclineRequestReasonCodeEnum reasonCode);

  DeclineRequest note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeclineRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeclineRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DeclineRequest call({DeclineRequestReasonCodeEnum reasonCode, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeclineRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeclineRequest.copyWith.fieldName(...)`
class _$DeclineRequestCWProxyImpl implements _$DeclineRequestCWProxy {
  const _$DeclineRequestCWProxyImpl(this._value);

  final DeclineRequest _value;

  @override
  DeclineRequest reasonCode(DeclineRequestReasonCodeEnum reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  DeclineRequest note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeclineRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeclineRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  DeclineRequest call({
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return DeclineRequest(
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as DeclineRequestReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $DeclineRequestCopyWith on DeclineRequest {
  /// Returns a callable class that can be used as follows: `instanceOfDeclineRequest.copyWith(...)` or like so:`instanceOfDeclineRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeclineRequestCWProxy get copyWith => _$DeclineRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclineRequest _$DeclineRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeclineRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reasonCode']);
      final val = DeclineRequest(
        reasonCode: $checkedConvert(
          'reasonCode',
          (v) => $enumDecode(_$DeclineRequestReasonCodeEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeclineRequestToJson(DeclineRequest instance) =>
    <String, dynamic>{
      'reasonCode': _$DeclineRequestReasonCodeEnumEnumMap[instance.reasonCode]!,
      'note': ?instance.note,
    };

const _$DeclineRequestReasonCodeEnumEnumMap = {
  DeclineRequestReasonCodeEnum.vehicleIssue: 'vehicle_issue',
  DeclineRequestReasonCodeEnum.unwell: 'unwell',
  DeclineRequestReasonCodeEnum.tooFar: 'too_far',
  DeclineRequestReasonCodeEnum.other: 'other',
};
