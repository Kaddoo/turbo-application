// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShiftCWProxy {
  Shift id(String id);

  Shift driverId(String driverId);

  Shift startsAt(DateTime startsAt);

  Shift endsAt(DateTime endsAt);

  Shift status(ShiftStatusEnum status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Shift(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Shift(...).copyWith(id: 12, name: "My name")
  /// ````
  Shift call({
    String id,
    String driverId,
    DateTime startsAt,
    DateTime endsAt,
    ShiftStatusEnum status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShift.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShift.copyWith.fieldName(...)`
class _$ShiftCWProxyImpl implements _$ShiftCWProxy {
  const _$ShiftCWProxyImpl(this._value);

  final Shift _value;

  @override
  Shift id(String id) => this(id: id);

  @override
  Shift driverId(String driverId) => this(driverId: driverId);

  @override
  Shift startsAt(DateTime startsAt) => this(startsAt: startsAt);

  @override
  Shift endsAt(DateTime endsAt) => this(endsAt: endsAt);

  @override
  Shift status(ShiftStatusEnum status) => this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Shift(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Shift(...).copyWith(id: 12, name: "My name")
  /// ````
  Shift call({
    Object? id = const $CopyWithPlaceholder(),
    Object? driverId = const $CopyWithPlaceholder(),
    Object? startsAt = const $CopyWithPlaceholder(),
    Object? endsAt = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return Shift(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      startsAt: startsAt == const $CopyWithPlaceholder()
          ? _value.startsAt
          // ignore: cast_nullable_to_non_nullable
          : startsAt as DateTime,
      endsAt: endsAt == const $CopyWithPlaceholder()
          ? _value.endsAt
          // ignore: cast_nullable_to_non_nullable
          : endsAt as DateTime,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ShiftStatusEnum,
    );
  }
}

extension $ShiftCopyWith on Shift {
  /// Returns a callable class that can be used as follows: `instanceOfShift.copyWith(...)` or like so:`instanceOfShift.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShiftCWProxy get copyWith => _$ShiftCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Shift',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['id', 'driverId', 'startsAt', 'endsAt', 'status'],
    );
    final val = Shift(
      id: $checkedConvert('id', (v) => v as String),
      driverId: $checkedConvert('driverId', (v) => v as String),
      startsAt: $checkedConvert('startsAt', (v) => DateTime.parse(v as String)),
      endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
      status: $checkedConvert(
        'status',
        (v) => $enumDecode(_$ShiftStatusEnumEnumMap, v),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
  'id': instance.id,
  'driverId': instance.driverId,
  'startsAt': instance.startsAt.toIso8601String(),
  'endsAt': instance.endsAt.toIso8601String(),
  'status': _$ShiftStatusEnumEnumMap[instance.status]!,
};

const _$ShiftStatusEnumEnumMap = {
  ShiftStatusEnum.scheduled: 'scheduled',
  ShiftStatusEnum.inProgress: 'in_progress',
  ShiftStatusEnum.completed: 'completed',
  ShiftStatusEnum.missed: 'missed',
};
