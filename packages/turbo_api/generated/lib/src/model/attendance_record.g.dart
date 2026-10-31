// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AttendanceRecordCWProxy {
  AttendanceRecord id(String id);

  AttendanceRecord driverId(String driverId);

  AttendanceRecord shiftId(String? shiftId);

  AttendanceRecord date(DateTime date);

  AttendanceRecord clockInAt(DateTime? clockInAt);

  AttendanceRecord clockOutAt(DateTime? clockOutAt);

  AttendanceRecord minutesWorked(int minutesWorked);

  AttendanceRecord status(AttendanceRecordStatusEnum status);

  AttendanceRecord correctionNote(String? correctionNote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceRecord(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceRecord(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceRecord call({
    String id,
    String driverId,
    String? shiftId,
    DateTime date,
    DateTime? clockInAt,
    DateTime? clockOutAt,
    int minutesWorked,
    AttendanceRecordStatusEnum status,
    String? correctionNote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAttendanceRecord.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAttendanceRecord.copyWith.fieldName(...)`
class _$AttendanceRecordCWProxyImpl implements _$AttendanceRecordCWProxy {
  const _$AttendanceRecordCWProxyImpl(this._value);

  final AttendanceRecord _value;

  @override
  AttendanceRecord id(String id) => this(id: id);

  @override
  AttendanceRecord driverId(String driverId) => this(driverId: driverId);

  @override
  AttendanceRecord shiftId(String? shiftId) => this(shiftId: shiftId);

  @override
  AttendanceRecord date(DateTime date) => this(date: date);

  @override
  AttendanceRecord clockInAt(DateTime? clockInAt) => this(clockInAt: clockInAt);

  @override
  AttendanceRecord clockOutAt(DateTime? clockOutAt) =>
      this(clockOutAt: clockOutAt);

  @override
  AttendanceRecord minutesWorked(int minutesWorked) =>
      this(minutesWorked: minutesWorked);

  @override
  AttendanceRecord status(AttendanceRecordStatusEnum status) =>
      this(status: status);

  @override
  AttendanceRecord correctionNote(String? correctionNote) =>
      this(correctionNote: correctionNote);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AttendanceRecord(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AttendanceRecord(...).copyWith(id: 12, name: "My name")
  /// ````
  AttendanceRecord call({
    Object? id = const $CopyWithPlaceholder(),
    Object? driverId = const $CopyWithPlaceholder(),
    Object? shiftId = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? clockInAt = const $CopyWithPlaceholder(),
    Object? clockOutAt = const $CopyWithPlaceholder(),
    Object? minutesWorked = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? correctionNote = const $CopyWithPlaceholder(),
  }) {
    return AttendanceRecord(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      shiftId: shiftId == const $CopyWithPlaceholder()
          ? _value.shiftId
          // ignore: cast_nullable_to_non_nullable
          : shiftId as String?,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      clockInAt: clockInAt == const $CopyWithPlaceholder()
          ? _value.clockInAt
          // ignore: cast_nullable_to_non_nullable
          : clockInAt as DateTime?,
      clockOutAt: clockOutAt == const $CopyWithPlaceholder()
          ? _value.clockOutAt
          // ignore: cast_nullable_to_non_nullable
          : clockOutAt as DateTime?,
      minutesWorked: minutesWorked == const $CopyWithPlaceholder()
          ? _value.minutesWorked
          // ignore: cast_nullable_to_non_nullable
          : minutesWorked as int,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AttendanceRecordStatusEnum,
      correctionNote: correctionNote == const $CopyWithPlaceholder()
          ? _value.correctionNote
          // ignore: cast_nullable_to_non_nullable
          : correctionNote as String?,
    );
  }
}

extension $AttendanceRecordCopyWith on AttendanceRecord {
  /// Returns a callable class that can be used as follows: `instanceOfAttendanceRecord.copyWith(...)` or like so:`instanceOfAttendanceRecord.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AttendanceRecordCWProxy get copyWith => _$AttendanceRecordCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecord _$AttendanceRecordFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AttendanceRecord', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'driverId', 'date', 'minutesWorked', 'status'],
  );
  final val = AttendanceRecord(
    id: $checkedConvert('id', (v) => v as String),
    driverId: $checkedConvert('driverId', (v) => v as String),
    shiftId: $checkedConvert('shiftId', (v) => v as String?),
    date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
    clockInAt: $checkedConvert(
      'clockInAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    clockOutAt: $checkedConvert(
      'clockOutAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    minutesWorked: $checkedConvert('minutesWorked', (v) => (v as num).toInt()),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$AttendanceRecordStatusEnumEnumMap, v),
    ),
    correctionNote: $checkedConvert('correctionNote', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AttendanceRecordToJson(AttendanceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'shiftId': ?instance.shiftId,
      'date': instance.date.toIso8601String(),
      'clockInAt': ?instance.clockInAt?.toIso8601String(),
      'clockOutAt': ?instance.clockOutAt?.toIso8601String(),
      'minutesWorked': instance.minutesWorked,
      'status': _$AttendanceRecordStatusEnumEnumMap[instance.status]!,
      'correctionNote': ?instance.correctionNote,
    };

const _$AttendanceRecordStatusEnumEnumMap = {
  AttendanceRecordStatusEnum.present: 'present',
  AttendanceRecordStatusEnum.late_: 'late',
  AttendanceRecordStatusEnum.absent: 'absent',
  AttendanceRecordStatusEnum.corrected: 'corrected',
};
