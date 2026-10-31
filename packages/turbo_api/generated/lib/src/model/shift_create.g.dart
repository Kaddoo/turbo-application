// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShiftCreateCWProxy {
  ShiftCreate driverId(String driverId);

  ShiftCreate startsAt(DateTime startsAt);

  ShiftCreate endsAt(DateTime endsAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShiftCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShiftCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  ShiftCreate call({String driverId, DateTime startsAt, DateTime endsAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShiftCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShiftCreate.copyWith.fieldName(...)`
class _$ShiftCreateCWProxyImpl implements _$ShiftCreateCWProxy {
  const _$ShiftCreateCWProxyImpl(this._value);

  final ShiftCreate _value;

  @override
  ShiftCreate driverId(String driverId) => this(driverId: driverId);

  @override
  ShiftCreate startsAt(DateTime startsAt) => this(startsAt: startsAt);

  @override
  ShiftCreate endsAt(DateTime endsAt) => this(endsAt: endsAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShiftCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShiftCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  ShiftCreate call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? startsAt = const $CopyWithPlaceholder(),
    Object? endsAt = const $CopyWithPlaceholder(),
  }) {
    return ShiftCreate(
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
    );
  }
}

extension $ShiftCreateCopyWith on ShiftCreate {
  /// Returns a callable class that can be used as follows: `instanceOfShiftCreate.copyWith(...)` or like so:`instanceOfShiftCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShiftCreateCWProxy get copyWith => _$ShiftCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftCreate _$ShiftCreateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ShiftCreate',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['driverId', 'startsAt', 'endsAt']);
    final val = ShiftCreate(
      driverId: $checkedConvert('driverId', (v) => v as String),
      startsAt: $checkedConvert('startsAt', (v) => DateTime.parse(v as String)),
      endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
    );
    return val;
  },
);

Map<String, dynamic> _$ShiftCreateToJson(ShiftCreate instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
    };
