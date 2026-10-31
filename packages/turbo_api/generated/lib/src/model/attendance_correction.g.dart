// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_correction.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AttendanceCorrectionCWProxy {
  AttendanceCorrection clockInAt(DateTime? clockInAt);

  AttendanceCorrection clockOutAt(DateTime? clockOutAt);

  AttendanceCorrection reasonCode(
    AttendanceCorrectionReasonCodeEnum reasonCode,
  );

  AttendanceCorrection note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceCorrection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceCorrection(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceCorrection call({
    DateTime? clockInAt,
    DateTime? clockOutAt,
    AttendanceCorrectionReasonCodeEnum reasonCode,
    String note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAttendanceCorrection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAttendanceCorrection.copyWith.fieldName(...)`
class _$AttendanceCorrectionCWProxyImpl
    implements _$AttendanceCorrectionCWProxy {
  const _$AttendanceCorrectionCWProxyImpl(this._value);

  final AttendanceCorrection _value;

  @override
  AttendanceCorrection clockInAt(DateTime? clockInAt) =>
      this(clockInAt: clockInAt);

  @override
  AttendanceCorrection clockOutAt(DateTime? clockOutAt) =>
      this(clockOutAt: clockOutAt);

  @override
  AttendanceCorrection reasonCode(
    AttendanceCorrectionReasonCodeEnum reasonCode,
  ) => this(reasonCode: reasonCode);

  @override
  AttendanceCorrection note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceCorrection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceCorrection(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceCorrection call({
    Object? clockInAt = const $CopyWithPlaceholder(),
    Object? clockOutAt = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return AttendanceCorrection(
      clockInAt: clockInAt == const $CopyWithPlaceholder()
          ? _value.clockInAt
          // ignore: cast_nullable_to_non_nullable
          : clockInAt as DateTime?,
      clockOutAt: clockOutAt == const $CopyWithPlaceholder()
          ? _value.clockOutAt
          // ignore: cast_nullable_to_non_nullable
          : clockOutAt as DateTime?,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as AttendanceCorrectionReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $AttendanceCorrectionCopyWith on AttendanceCorrection {
  /// Returns a callable class that can be used as follows: `instanceOfAttendanceCorrection.copyWith(...)` or like so:`instanceOfAttendanceCorrection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AttendanceCorrectionCWProxy get copyWith =>
      _$AttendanceCorrectionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCorrection _$AttendanceCorrectionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AttendanceCorrection', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['reasonCode', 'note']);
  final val = AttendanceCorrection(
    clockInAt: $checkedConvert(
      'clockInAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    clockOutAt: $checkedConvert(
      'clockOutAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    reasonCode: $checkedConvert(
      'reasonCode',
      (v) => $enumDecode(_$AttendanceCorrectionReasonCodeEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AttendanceCorrectionToJson(
  AttendanceCorrection instance,
) => <String, dynamic>{
  'clockInAt': ?instance.clockInAt?.toIso8601String(),
  'clockOutAt': ?instance.clockOutAt?.toIso8601String(),
  'reasonCode':
      _$AttendanceCorrectionReasonCodeEnumEnumMap[instance.reasonCode]!,
  'note': instance.note,
};

const _$AttendanceCorrectionReasonCodeEnumEnumMap = {
  AttendanceCorrectionReasonCodeEnum.forgotToClock: 'forgot_to_clock',
  AttendanceCorrectionReasonCodeEnum.appIssue: 'app_issue',
  AttendanceCorrectionReasonCodeEnum.approvedLeave: 'approved_leave',
  AttendanceCorrectionReasonCodeEnum.other: 'other',
};
