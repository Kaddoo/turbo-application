// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RideCWProxy {
  Ride id(String id);

  Ride status(RideStatus status);

  Ride pickup(Location pickup);

  Ride dropoff(Location dropoff);

  Ride routeDistanceMeters(int routeDistanceMeters);

  Ride routePolyline(String? routePolyline);

  Ride farePesewas(int farePesewas);

  Ride pin(String? pin);

  Ride pickupEtaSeconds(int? pickupEtaSeconds);

  Ride driver(DriverPublic? driver);

  Ride vehicle(VehiclePublic? vehicle);

  Ride payment(RidePayment payment);

  Ride cancellation(Cancellation? cancellation);

  Ride requestedAt(DateTime requestedAt);

  Ride assignedAt(DateTime? assignedAt);

  Ride driverArrivedAt(DateTime? driverArrivedAt);

  Ride startedAt(DateTime? startedAt);

  Ride completedAt(DateTime? completedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ride(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ride(...).copyWith(id: 12, name: "My name")
  /// ````
  Ride call({
    String id,
    RideStatus status,
    Location pickup,
    Location dropoff,
    int routeDistanceMeters,
    String? routePolyline,
    int farePesewas,
    String? pin,
    int? pickupEtaSeconds,
    DriverPublic? driver,
    VehiclePublic? vehicle,
    RidePayment payment,
    Cancellation? cancellation,
    DateTime requestedAt,
    DateTime? assignedAt,
    DateTime? driverArrivedAt,
    DateTime? startedAt,
    DateTime? completedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRide.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRide.copyWith.fieldName(...)`
class _$RideCWProxyImpl implements _$RideCWProxy {
  const _$RideCWProxyImpl(this._value);

  final Ride _value;

  @override
  Ride id(String id) => this(id: id);

  @override
  Ride status(RideStatus status) => this(status: status);

  @override
  Ride pickup(Location pickup) => this(pickup: pickup);

  @override
  Ride dropoff(Location dropoff) => this(dropoff: dropoff);

  @override
  Ride routeDistanceMeters(int routeDistanceMeters) =>
      this(routeDistanceMeters: routeDistanceMeters);

  @override
  Ride routePolyline(String? routePolyline) =>
      this(routePolyline: routePolyline);

  @override
  Ride farePesewas(int farePesewas) => this(farePesewas: farePesewas);

  @override
  Ride pin(String? pin) => this(pin: pin);

  @override
  Ride pickupEtaSeconds(int? pickupEtaSeconds) =>
      this(pickupEtaSeconds: pickupEtaSeconds);

  @override
  Ride driver(DriverPublic? driver) => this(driver: driver);

  @override
  Ride vehicle(VehiclePublic? vehicle) => this(vehicle: vehicle);

  @override
  Ride payment(RidePayment payment) => this(payment: payment);

  @override
  Ride cancellation(Cancellation? cancellation) =>
      this(cancellation: cancellation);

  @override
  Ride requestedAt(DateTime requestedAt) => this(requestedAt: requestedAt);

  @override
  Ride assignedAt(DateTime? assignedAt) => this(assignedAt: assignedAt);

  @override
  Ride driverArrivedAt(DateTime? driverArrivedAt) =>
      this(driverArrivedAt: driverArrivedAt);

  @override
  Ride startedAt(DateTime? startedAt) => this(startedAt: startedAt);

  @override
  Ride completedAt(DateTime? completedAt) => this(completedAt: completedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ride(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ride(...).copyWith(id: 12, name: "My name")
  /// ````
  Ride call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? pickup = const $CopyWithPlaceholder(),
    Object? dropoff = const $CopyWithPlaceholder(),
    Object? routeDistanceMeters = const $CopyWithPlaceholder(),
    Object? routePolyline = const $CopyWithPlaceholder(),
    Object? farePesewas = const $CopyWithPlaceholder(),
    Object? pin = const $CopyWithPlaceholder(),
    Object? pickupEtaSeconds = const $CopyWithPlaceholder(),
    Object? driver = const $CopyWithPlaceholder(),
    Object? vehicle = const $CopyWithPlaceholder(),
    Object? payment = const $CopyWithPlaceholder(),
    Object? cancellation = const $CopyWithPlaceholder(),
    Object? requestedAt = const $CopyWithPlaceholder(),
    Object? assignedAt = const $CopyWithPlaceholder(),
    Object? driverArrivedAt = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
  }) {
    return Ride(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RideStatus,
      pickup: pickup == const $CopyWithPlaceholder()
          ? _value.pickup
          // ignore: cast_nullable_to_non_nullable
          : pickup as Location,
      dropoff: dropoff == const $CopyWithPlaceholder()
          ? _value.dropoff
          // ignore: cast_nullable_to_non_nullable
          : dropoff as Location,
      routeDistanceMeters: routeDistanceMeters == const $CopyWithPlaceholder()
          ? _value.routeDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : routeDistanceMeters as int,
      routePolyline: routePolyline == const $CopyWithPlaceholder()
          ? _value.routePolyline
          // ignore: cast_nullable_to_non_nullable
          : routePolyline as String?,
      farePesewas: farePesewas == const $CopyWithPlaceholder()
          ? _value.farePesewas
          // ignore: cast_nullable_to_non_nullable
          : farePesewas as int,
      pin: pin == const $CopyWithPlaceholder()
          ? _value.pin
          // ignore: cast_nullable_to_non_nullable
          : pin as String?,
      pickupEtaSeconds: pickupEtaSeconds == const $CopyWithPlaceholder()
          ? _value.pickupEtaSeconds
          // ignore: cast_nullable_to_non_nullable
          : pickupEtaSeconds as int?,
      driver: driver == const $CopyWithPlaceholder()
          ? _value.driver
          // ignore: cast_nullable_to_non_nullable
          : driver as DriverPublic?,
      vehicle: vehicle == const $CopyWithPlaceholder()
          ? _value.vehicle
          // ignore: cast_nullable_to_non_nullable
          : vehicle as VehiclePublic?,
      payment: payment == const $CopyWithPlaceholder()
          ? _value.payment
          // ignore: cast_nullable_to_non_nullable
          : payment as RidePayment,
      cancellation: cancellation == const $CopyWithPlaceholder()
          ? _value.cancellation
          // ignore: cast_nullable_to_non_nullable
          : cancellation as Cancellation?,
      requestedAt: requestedAt == const $CopyWithPlaceholder()
          ? _value.requestedAt
          // ignore: cast_nullable_to_non_nullable
          : requestedAt as DateTime,
      assignedAt: assignedAt == const $CopyWithPlaceholder()
          ? _value.assignedAt
          // ignore: cast_nullable_to_non_nullable
          : assignedAt as DateTime?,
      driverArrivedAt: driverArrivedAt == const $CopyWithPlaceholder()
          ? _value.driverArrivedAt
          // ignore: cast_nullable_to_non_nullable
          : driverArrivedAt as DateTime?,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime?,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
    );
  }
}

extension $RideCopyWith on Ride {
  /// Returns a callable class that can be used as follows: `instanceOfRide.copyWith(...)` or like so:`instanceOfRide.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RideCWProxy get copyWith => _$RideCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => $checkedCreate('Ride', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'status',
      'pickup',
      'dropoff',
      'routeDistanceMeters',
      'farePesewas',
      'payment',
      'requestedAt',
    ],
  );
  final val = Ride(
    id: $checkedConvert('id', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$RideStatusEnumMap, v),
    ),
    pickup: $checkedConvert(
      'pickup',
      (v) => Location.fromJson(v as Map<String, dynamic>),
    ),
    dropoff: $checkedConvert(
      'dropoff',
      (v) => Location.fromJson(v as Map<String, dynamic>),
    ),
    routeDistanceMeters: $checkedConvert(
      'routeDistanceMeters',
      (v) => (v as num).toInt(),
    ),
    routePolyline: $checkedConvert('routePolyline', (v) => v as String?),
    farePesewas: $checkedConvert('farePesewas', (v) => (v as num).toInt()),
    pin: $checkedConvert('pin', (v) => v as String?),
    pickupEtaSeconds: $checkedConvert(
      'pickupEtaSeconds',
      (v) => (v as num?)?.toInt(),
    ),
    driver: $checkedConvert(
      'driver',
      (v) =>
          v == null ? null : DriverPublic.fromJson(v as Map<String, dynamic>),
    ),
    vehicle: $checkedConvert(
      'vehicle',
      (v) =>
          v == null ? null : VehiclePublic.fromJson(v as Map<String, dynamic>),
    ),
    payment: $checkedConvert(
      'payment',
      (v) => RidePayment.fromJson(v as Map<String, dynamic>),
    ),
    cancellation: $checkedConvert(
      'cancellation',
      (v) =>
          v == null ? null : Cancellation.fromJson(v as Map<String, dynamic>),
    ),
    requestedAt: $checkedConvert(
      'requestedAt',
      (v) => DateTime.parse(v as String),
    ),
    assignedAt: $checkedConvert(
      'assignedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    driverArrivedAt: $checkedConvert(
      'driverArrivedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    startedAt: $checkedConvert(
      'startedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    completedAt: $checkedConvert(
      'completedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$RideStatusEnumMap[instance.status]!,
  'pickup': instance.pickup.toJson(),
  'dropoff': instance.dropoff.toJson(),
  'routeDistanceMeters': instance.routeDistanceMeters,
  'routePolyline': ?instance.routePolyline,
  'farePesewas': instance.farePesewas,
  'pin': ?instance.pin,
  'pickupEtaSeconds': ?instance.pickupEtaSeconds,
  'driver': ?instance.driver?.toJson(),
  'vehicle': ?instance.vehicle?.toJson(),
  'payment': instance.payment.toJson(),
  'cancellation': ?instance.cancellation?.toJson(),
  'requestedAt': instance.requestedAt.toIso8601String(),
  'assignedAt': ?instance.assignedAt?.toIso8601String(),
  'driverArrivedAt': ?instance.driverArrivedAt?.toIso8601String(),
  'startedAt': ?instance.startedAt?.toIso8601String(),
  'completedAt': ?instance.completedAt?.toIso8601String(),
};

const _$RideStatusEnumMap = {
  RideStatus.searching: 'searching',
  RideStatus.assigned: 'assigned',
  RideStatus.driverArrived: 'driver_arrived',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};
