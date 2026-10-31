// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_rides_on_duty_drivers_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveRidesOnDutyDriversInnerCWProxy {
  LiveRidesOnDutyDriversInner driverId(String driverId);

  LiveRidesOnDutyDriversInner fullName(String fullName);

  LiveRidesOnDutyDriversInner idle(bool idle);

  LiveRidesOnDutyDriversInner location(DriverLocation? location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRidesOnDutyDriversInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRidesOnDutyDriversInner(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRidesOnDutyDriversInner call({
    String driverId,
    String fullName,
    bool idle,
    DriverLocation? location,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveRidesOnDutyDriversInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLiveRidesOnDutyDriversInner.copyWith.fieldName(...)`
class _$LiveRidesOnDutyDriversInnerCWProxyImpl
    implements _$LiveRidesOnDutyDriversInnerCWProxy {
  const _$LiveRidesOnDutyDriversInnerCWProxyImpl(this._value);

  final LiveRidesOnDutyDriversInner _value;

  @override
  LiveRidesOnDutyDriversInner driverId(String driverId) =>
      this(driverId: driverId);

  @override
  LiveRidesOnDutyDriversInner fullName(String fullName) =>
      this(fullName: fullName);

  @override
  LiveRidesOnDutyDriversInner idle(bool idle) => this(idle: idle);

  @override
  LiveRidesOnDutyDriversInner location(DriverLocation? location) =>
      this(location: location);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRidesOnDutyDriversInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRidesOnDutyDriversInner(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRidesOnDutyDriversInner call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? idle = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
  }) {
    return LiveRidesOnDutyDriversInner(
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      idle: idle == const $CopyWithPlaceholder()
          ? _value.idle
          // ignore: cast_nullable_to_non_nullable
          : idle as bool,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as DriverLocation?,
    );
  }
}

extension $LiveRidesOnDutyDriversInnerCopyWith on LiveRidesOnDutyDriversInner {
  /// Returns a callable class that can be used as follows: `instanceOfLiveRidesOnDutyDriversInner.copyWith(...)` or like so:`instanceOfLiveRidesOnDutyDriversInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveRidesOnDutyDriversInnerCWProxy get copyWith =>
      _$LiveRidesOnDutyDriversInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveRidesOnDutyDriversInner _$LiveRidesOnDutyDriversInnerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LiveRidesOnDutyDriversInner', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['driverId', 'fullName', 'idle']);
  final val = LiveRidesOnDutyDriversInner(
    driverId: $checkedConvert('driverId', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String),
    idle: $checkedConvert('idle', (v) => v as bool),
    location: $checkedConvert(
      'location',
      (v) =>
          v == null ? null : DriverLocation.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$LiveRidesOnDutyDriversInnerToJson(
  LiveRidesOnDutyDriversInner instance,
) => <String, dynamic>{
  'driverId': instance.driverId,
  'fullName': instance.fullName,
  'idle': instance.idle,
  'location': ?instance.location?.toJson(),
};
