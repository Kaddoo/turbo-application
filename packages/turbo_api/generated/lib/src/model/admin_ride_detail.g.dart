// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ride_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminRideDetailCWProxy {
  AdminRideDetail ride(Ride ride);

  AdminRideDetail student(StudentSummary student);

  AdminRideDetail driver(DriverDetail? driver);

  AdminRideDetail events(List<RideEvent> events);

  AdminRideDetail flags(List<RideFlag>? flags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideDetail call({
    Ride ride,
    StudentSummary student,
    DriverDetail? driver,
    List<RideEvent> events,
    List<RideFlag>? flags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminRideDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminRideDetail.copyWith.fieldName(...)`
class _$AdminRideDetailCWProxyImpl implements _$AdminRideDetailCWProxy {
  const _$AdminRideDetailCWProxyImpl(this._value);

  final AdminRideDetail _value;

  @override
  AdminRideDetail ride(Ride ride) => this(ride: ride);

  @override
  AdminRideDetail student(StudentSummary student) => this(student: student);

  @override
  AdminRideDetail driver(DriverDetail? driver) => this(driver: driver);

  @override
  AdminRideDetail events(List<RideEvent> events) => this(events: events);

  @override
  AdminRideDetail flags(List<RideFlag>? flags) => this(flags: flags);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideDetail call({
    Object? ride = const $CopyWithPlaceholder(),
    Object? student = const $CopyWithPlaceholder(),
    Object? driver = const $CopyWithPlaceholder(),
    Object? events = const $CopyWithPlaceholder(),
    Object? flags = const $CopyWithPlaceholder(),
  }) {
    return AdminRideDetail(
      ride: ride == const $CopyWithPlaceholder()
          ? _value.ride
          // ignore: cast_nullable_to_non_nullable
          : ride as Ride,
      student: student == const $CopyWithPlaceholder()
          ? _value.student
          // ignore: cast_nullable_to_non_nullable
          : student as StudentSummary,
      driver: driver == const $CopyWithPlaceholder()
          ? _value.driver
          // ignore: cast_nullable_to_non_nullable
          : driver as DriverDetail?,
      events: events == const $CopyWithPlaceholder()
          ? _value.events
          // ignore: cast_nullable_to_non_nullable
          : events as List<RideEvent>,
      flags: flags == const $CopyWithPlaceholder()
          ? _value.flags
          // ignore: cast_nullable_to_non_nullable
          : flags as List<RideFlag>?,
    );
  }
}

extension $AdminRideDetailCopyWith on AdminRideDetail {
  /// Returns a callable class that can be used as follows: `instanceOfAdminRideDetail.copyWith(...)` or like so:`instanceOfAdminRideDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminRideDetailCWProxy get copyWith => _$AdminRideDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRideDetail _$AdminRideDetailFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminRideDetail', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ride', 'student', 'events']);
      final val = AdminRideDetail(
        ride: $checkedConvert(
          'ride',
          (v) => Ride.fromJson(v as Map<String, dynamic>),
        ),
        student: $checkedConvert(
          'student',
          (v) => StudentSummary.fromJson(v as Map<String, dynamic>),
        ),
        driver: $checkedConvert(
          'driver',
          (v) => v == null
              ? null
              : DriverDetail.fromJson(v as Map<String, dynamic>),
        ),
        events: $checkedConvert(
          'events',
          (v) => (v as List<dynamic>)
              .map((e) => RideEvent.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        flags: $checkedConvert(
          'flags',
          (v) => (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$RideFlagEnumMap, e))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminRideDetailToJson(AdminRideDetail instance) =>
    <String, dynamic>{
      'ride': instance.ride.toJson(),
      'student': instance.student.toJson(),
      'driver': ?instance.driver?.toJson(),
      'events': instance.events.map((e) => e.toJson()).toList(),
      'flags': ?instance.flags?.map((e) => _$RideFlagEnumMap[e]!).toList(),
    };

const _$RideFlagEnumMap = {
  RideFlag.driverUnreachable: 'driver_unreachable',
  RideFlag.overdue: 'overdue',
  RideFlag.completedFarFromDestination: 'completed_far_from_destination',
  RideFlag.completedTooFast: 'completed_too_fast',
};
