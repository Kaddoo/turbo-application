// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackingCWProxy {
  Tracking rideStatus(RideStatus rideStatus);

  Tracking driverLocation(DriverLocation? driverLocation);

  Tracking etaSeconds(int? etaSeconds);

  Tracking updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Tracking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Tracking(...).copyWith(id: 12, name: "My name")
  /// ````
  Tracking call({
    RideStatus rideStatus,
    DriverLocation? driverLocation,
    int? etaSeconds,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTracking.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTracking.copyWith.fieldName(...)`
class _$TrackingCWProxyImpl implements _$TrackingCWProxy {
  const _$TrackingCWProxyImpl(this._value);

  final Tracking _value;

  @override
  Tracking rideStatus(RideStatus rideStatus) => this(rideStatus: rideStatus);

  @override
  Tracking driverLocation(DriverLocation? driverLocation) =>
      this(driverLocation: driverLocation);

  @override
  Tracking etaSeconds(int? etaSeconds) => this(etaSeconds: etaSeconds);

  @override
  Tracking updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Tracking(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Tracking(...).copyWith(id: 12, name: "My name")
  /// ````
  Tracking call({
    Object? rideStatus = const $CopyWithPlaceholder(),
    Object? driverLocation = const $CopyWithPlaceholder(),
    Object? etaSeconds = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return Tracking(
      rideStatus: rideStatus == const $CopyWithPlaceholder()
          ? _value.rideStatus
          // ignore: cast_nullable_to_non_nullable
          : rideStatus as RideStatus,
      driverLocation: driverLocation == const $CopyWithPlaceholder()
          ? _value.driverLocation
          // ignore: cast_nullable_to_non_nullable
          : driverLocation as DriverLocation?,
      etaSeconds: etaSeconds == const $CopyWithPlaceholder()
          ? _value.etaSeconds
          // ignore: cast_nullable_to_non_nullable
          : etaSeconds as int?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $TrackingCopyWith on Tracking {
  /// Returns a callable class that can be used as follows: `instanceOfTracking.copyWith(...)` or like so:`instanceOfTracking.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackingCWProxy get copyWith => _$TrackingCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tracking _$TrackingFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Tracking', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['rideStatus', 'driverLocation', 'updatedAt'],
  );
  final val = Tracking(
    rideStatus: $checkedConvert(
      'rideStatus',
      (v) => $enumDecode(_$RideStatusEnumMap, v),
    ),
    driverLocation: $checkedConvert(
      'driverLocation',
      (v) =>
          v == null ? null : DriverLocation.fromJson(v as Map<String, dynamic>),
    ),
    etaSeconds: $checkedConvert('etaSeconds', (v) => (v as num?)?.toInt()),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$TrackingToJson(Tracking instance) => <String, dynamic>{
  'rideStatus': _$RideStatusEnumMap[instance.rideStatus]!,
  'driverLocation': instance.driverLocation?.toJson(),
  'etaSeconds': ?instance.etaSeconds,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$RideStatusEnumMap = {
  RideStatus.searching: 'searching',
  RideStatus.assigned: 'assigned',
  RideStatus.driverArrived: 'driver_arrived',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};
