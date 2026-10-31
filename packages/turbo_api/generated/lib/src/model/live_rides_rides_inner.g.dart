// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_rides_rides_inner.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveRidesRidesInnerCWProxy {
  LiveRidesRidesInner ride(AdminRideSummary ride);

  LiveRidesRidesInner driverLocation(DriverLocation? driverLocation);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRidesRidesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRidesRidesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRidesRidesInner call({
    AdminRideSummary ride,
    DriverLocation? driverLocation,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveRidesRidesInner.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLiveRidesRidesInner.copyWith.fieldName(...)`
class _$LiveRidesRidesInnerCWProxyImpl implements _$LiveRidesRidesInnerCWProxy {
  const _$LiveRidesRidesInnerCWProxyImpl(this._value);

  final LiveRidesRidesInner _value;

  @override
  LiveRidesRidesInner ride(AdminRideSummary ride) => this(ride: ride);

  @override
  LiveRidesRidesInner driverLocation(DriverLocation? driverLocation) =>
      this(driverLocation: driverLocation);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRidesRidesInner(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRidesRidesInner(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRidesRidesInner call({
    Object? ride = const $CopyWithPlaceholder(),
    Object? driverLocation = const $CopyWithPlaceholder(),
  }) {
    return LiveRidesRidesInner(
      ride: ride == const $CopyWithPlaceholder()
          ? _value.ride
          // ignore: cast_nullable_to_non_nullable
          : ride as AdminRideSummary,
      driverLocation: driverLocation == const $CopyWithPlaceholder()
          ? _value.driverLocation
          // ignore: cast_nullable_to_non_nullable
          : driverLocation as DriverLocation?,
    );
  }
}

extension $LiveRidesRidesInnerCopyWith on LiveRidesRidesInner {
  /// Returns a callable class that can be used as follows: `instanceOfLiveRidesRidesInner.copyWith(...)` or like so:`instanceOfLiveRidesRidesInner.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveRidesRidesInnerCWProxy get copyWith =>
      _$LiveRidesRidesInnerCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveRidesRidesInner _$LiveRidesRidesInnerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LiveRidesRidesInner', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ride']);
      final val = LiveRidesRidesInner(
        ride: $checkedConvert(
          'ride',
          (v) => AdminRideSummary.fromJson(v as Map<String, dynamic>),
        ),
        driverLocation: $checkedConvert(
          'driverLocation',
          (v) => v == null
              ? null
              : DriverLocation.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LiveRidesRidesInnerToJson(
  LiveRidesRidesInner instance,
) => <String, dynamic>{
  'ride': instance.ride.toJson(),
  'driverLocation': ?instance.driverLocation?.toJson(),
};
