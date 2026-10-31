// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_share.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PublicTripShareCWProxy {
  PublicTripShare rideStatus(RideStatus rideStatus);

  PublicTripShare studentFirstName(String studentFirstName);

  PublicTripShare driverFirstName(String? driverFirstName);

  PublicTripShare vehicle(VehiclePublic? vehicle);

  PublicTripShare driverLocation(DriverLocation? driverLocation);

  PublicTripShare dropoff(Location dropoff);

  PublicTripShare expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicTripShare(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicTripShare(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicTripShare call({
    RideStatus rideStatus,
    String studentFirstName,
    String? driverFirstName,
    VehiclePublic? vehicle,
    DriverLocation? driverLocation,
    Location dropoff,
    DateTime expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPublicTripShare.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPublicTripShare.copyWith.fieldName(...)`
class _$PublicTripShareCWProxyImpl implements _$PublicTripShareCWProxy {
  const _$PublicTripShareCWProxyImpl(this._value);

  final PublicTripShare _value;

  @override
  PublicTripShare rideStatus(RideStatus rideStatus) =>
      this(rideStatus: rideStatus);

  @override
  PublicTripShare studentFirstName(String studentFirstName) =>
      this(studentFirstName: studentFirstName);

  @override
  PublicTripShare driverFirstName(String? driverFirstName) =>
      this(driverFirstName: driverFirstName);

  @override
  PublicTripShare vehicle(VehiclePublic? vehicle) => this(vehicle: vehicle);

  @override
  PublicTripShare driverLocation(DriverLocation? driverLocation) =>
      this(driverLocation: driverLocation);

  @override
  PublicTripShare dropoff(Location dropoff) => this(dropoff: dropoff);

  @override
  PublicTripShare expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicTripShare(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicTripShare(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicTripShare call({
    Object? rideStatus = const $CopyWithPlaceholder(),
    Object? studentFirstName = const $CopyWithPlaceholder(),
    Object? driverFirstName = const $CopyWithPlaceholder(),
    Object? vehicle = const $CopyWithPlaceholder(),
    Object? driverLocation = const $CopyWithPlaceholder(),
    Object? dropoff = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return PublicTripShare(
      rideStatus: rideStatus == const $CopyWithPlaceholder()
          ? _value.rideStatus
          // ignore: cast_nullable_to_non_nullable
          : rideStatus as RideStatus,
      studentFirstName: studentFirstName == const $CopyWithPlaceholder()
          ? _value.studentFirstName
          // ignore: cast_nullable_to_non_nullable
          : studentFirstName as String,
      driverFirstName: driverFirstName == const $CopyWithPlaceholder()
          ? _value.driverFirstName
          // ignore: cast_nullable_to_non_nullable
          : driverFirstName as String?,
      vehicle: vehicle == const $CopyWithPlaceholder()
          ? _value.vehicle
          // ignore: cast_nullable_to_non_nullable
          : vehicle as VehiclePublic?,
      driverLocation: driverLocation == const $CopyWithPlaceholder()
          ? _value.driverLocation
          // ignore: cast_nullable_to_non_nullable
          : driverLocation as DriverLocation?,
      dropoff: dropoff == const $CopyWithPlaceholder()
          ? _value.dropoff
          // ignore: cast_nullable_to_non_nullable
          : dropoff as Location,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $PublicTripShareCopyWith on PublicTripShare {
  /// Returns a callable class that can be used as follows: `instanceOfPublicTripShare.copyWith(...)` or like so:`instanceOfPublicTripShare.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PublicTripShareCWProxy get copyWith => _$PublicTripShareCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicTripShare _$PublicTripShareFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PublicTripShare', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'rideStatus',
      'studentFirstName',
      'dropoff',
      'expiresAt',
    ],
  );
  final val = PublicTripShare(
    rideStatus: $checkedConvert(
      'rideStatus',
      (v) => $enumDecode(_$RideStatusEnumMap, v),
    ),
    studentFirstName: $checkedConvert('studentFirstName', (v) => v as String),
    driverFirstName: $checkedConvert('driverFirstName', (v) => v as String?),
    vehicle: $checkedConvert(
      'vehicle',
      (v) =>
          v == null ? null : VehiclePublic.fromJson(v as Map<String, dynamic>),
    ),
    driverLocation: $checkedConvert(
      'driverLocation',
      (v) =>
          v == null ? null : DriverLocation.fromJson(v as Map<String, dynamic>),
    ),
    dropoff: $checkedConvert(
      'dropoff',
      (v) => Location.fromJson(v as Map<String, dynamic>),
    ),
    expiresAt: $checkedConvert('expiresAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$PublicTripShareToJson(PublicTripShare instance) =>
    <String, dynamic>{
      'rideStatus': _$RideStatusEnumMap[instance.rideStatus]!,
      'studentFirstName': instance.studentFirstName,
      'driverFirstName': ?instance.driverFirstName,
      'vehicle': ?instance.vehicle?.toJson(),
      'driverLocation': ?instance.driverLocation?.toJson(),
      'dropoff': instance.dropoff.toJson(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

const _$RideStatusEnumMap = {
  RideStatus.searching: 'searching',
  RideStatus.assigned: 'assigned',
  RideStatus.driverArrived: 'driver_arrived',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};
