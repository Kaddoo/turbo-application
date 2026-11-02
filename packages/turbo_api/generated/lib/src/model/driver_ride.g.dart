// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_ride.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverRideCWProxy {
  DriverRide id(String id);

  DriverRide status(RideStatus status);

  DriverRide pickup(Location pickup);

  DriverRide dropoff(Location dropoff);

  DriverRide routeDistanceMeters(int routeDistanceMeters);

  DriverRide routePolyline(String? routePolyline);

  DriverRide farePesewas(int? farePesewas);

  DriverRide pickupDistanceMeters(int? pickupDistanceMeters);

  DriverRide pickupEtaSeconds(int? pickupEtaSeconds);

  DriverRide routeDurationSeconds(int? routeDurationSeconds);

  DriverRide student(DriverRideStudent student);

  DriverRide assignedAt(DateTime assignedAt);

  DriverRide acknowledgedAt(DateTime? acknowledgedAt);

  DriverRide noShowAvailableAt(DateTime? noShowAvailableAt);

  DriverRide arrivedAt(DateTime? arrivedAt);

  DriverRide startedAt(DateTime? startedAt);

  DriverRide completedAt(DateTime? completedAt);

  DriverRide cancelledAt(DateTime? cancelledAt);

  DriverRide cancelledBy(DriverRideCancelledByEnum? cancelledBy);

  DriverRide cancelReasonCode(DriverRideCancelReasonCodeEnum? cancelReasonCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRide(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRide(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRide call({
    String id,
    RideStatus status,
    Location pickup,
    Location dropoff,
    int routeDistanceMeters,
    String? routePolyline,
    int? farePesewas,
    int? pickupDistanceMeters,
    int? pickupEtaSeconds,
    int? routeDurationSeconds,
    DriverRideStudent student,
    DateTime assignedAt,
    DateTime? acknowledgedAt,
    DateTime? noShowAvailableAt,
    DateTime? arrivedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DriverRideCancelledByEnum? cancelledBy,
    DriverRideCancelReasonCodeEnum? cancelReasonCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverRide.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverRide.copyWith.fieldName(...)`
class _$DriverRideCWProxyImpl implements _$DriverRideCWProxy {
  const _$DriverRideCWProxyImpl(this._value);

  final DriverRide _value;

  @override
  DriverRide id(String id) => this(id: id);

  @override
  DriverRide status(RideStatus status) => this(status: status);

  @override
  DriverRide pickup(Location pickup) => this(pickup: pickup);

  @override
  DriverRide dropoff(Location dropoff) => this(dropoff: dropoff);

  @override
  DriverRide routeDistanceMeters(int routeDistanceMeters) =>
      this(routeDistanceMeters: routeDistanceMeters);

  @override
  DriverRide routePolyline(String? routePolyline) =>
      this(routePolyline: routePolyline);

  @override
  DriverRide farePesewas(int? farePesewas) => this(farePesewas: farePesewas);

  @override
  DriverRide pickupDistanceMeters(int? pickupDistanceMeters) =>
      this(pickupDistanceMeters: pickupDistanceMeters);

  @override
  DriverRide pickupEtaSeconds(int? pickupEtaSeconds) =>
      this(pickupEtaSeconds: pickupEtaSeconds);

  @override
  DriverRide routeDurationSeconds(int? routeDurationSeconds) =>
      this(routeDurationSeconds: routeDurationSeconds);

  @override
  DriverRide student(DriverRideStudent student) => this(student: student);

  @override
  DriverRide assignedAt(DateTime assignedAt) => this(assignedAt: assignedAt);

  @override
  DriverRide acknowledgedAt(DateTime? acknowledgedAt) =>
      this(acknowledgedAt: acknowledgedAt);

  @override
  DriverRide noShowAvailableAt(DateTime? noShowAvailableAt) =>
      this(noShowAvailableAt: noShowAvailableAt);

  @override
  DriverRide arrivedAt(DateTime? arrivedAt) => this(arrivedAt: arrivedAt);

  @override
  DriverRide startedAt(DateTime? startedAt) => this(startedAt: startedAt);

  @override
  DriverRide completedAt(DateTime? completedAt) =>
      this(completedAt: completedAt);

  @override
  DriverRide cancelledAt(DateTime? cancelledAt) =>
      this(cancelledAt: cancelledAt);

  @override
  DriverRide cancelledBy(DriverRideCancelledByEnum? cancelledBy) =>
      this(cancelledBy: cancelledBy);

  @override
  DriverRide cancelReasonCode(
    DriverRideCancelReasonCodeEnum? cancelReasonCode,
  ) => this(cancelReasonCode: cancelReasonCode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRide(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRide(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRide call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? pickup = const $CopyWithPlaceholder(),
    Object? dropoff = const $CopyWithPlaceholder(),
    Object? routeDistanceMeters = const $CopyWithPlaceholder(),
    Object? routePolyline = const $CopyWithPlaceholder(),
    Object? farePesewas = const $CopyWithPlaceholder(),
    Object? pickupDistanceMeters = const $CopyWithPlaceholder(),
    Object? pickupEtaSeconds = const $CopyWithPlaceholder(),
    Object? routeDurationSeconds = const $CopyWithPlaceholder(),
    Object? student = const $CopyWithPlaceholder(),
    Object? assignedAt = const $CopyWithPlaceholder(),
    Object? acknowledgedAt = const $CopyWithPlaceholder(),
    Object? noShowAvailableAt = const $CopyWithPlaceholder(),
    Object? arrivedAt = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
    Object? cancelledAt = const $CopyWithPlaceholder(),
    Object? cancelledBy = const $CopyWithPlaceholder(),
    Object? cancelReasonCode = const $CopyWithPlaceholder(),
  }) {
    return DriverRide(
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
          : farePesewas as int?,
      pickupDistanceMeters: pickupDistanceMeters == const $CopyWithPlaceholder()
          ? _value.pickupDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : pickupDistanceMeters as int?,
      pickupEtaSeconds: pickupEtaSeconds == const $CopyWithPlaceholder()
          ? _value.pickupEtaSeconds
          // ignore: cast_nullable_to_non_nullable
          : pickupEtaSeconds as int?,
      routeDurationSeconds: routeDurationSeconds == const $CopyWithPlaceholder()
          ? _value.routeDurationSeconds
          // ignore: cast_nullable_to_non_nullable
          : routeDurationSeconds as int?,
      student: student == const $CopyWithPlaceholder()
          ? _value.student
          // ignore: cast_nullable_to_non_nullable
          : student as DriverRideStudent,
      assignedAt: assignedAt == const $CopyWithPlaceholder()
          ? _value.assignedAt
          // ignore: cast_nullable_to_non_nullable
          : assignedAt as DateTime,
      acknowledgedAt: acknowledgedAt == const $CopyWithPlaceholder()
          ? _value.acknowledgedAt
          // ignore: cast_nullable_to_non_nullable
          : acknowledgedAt as DateTime?,
      noShowAvailableAt: noShowAvailableAt == const $CopyWithPlaceholder()
          ? _value.noShowAvailableAt
          // ignore: cast_nullable_to_non_nullable
          : noShowAvailableAt as DateTime?,
      arrivedAt: arrivedAt == const $CopyWithPlaceholder()
          ? _value.arrivedAt
          // ignore: cast_nullable_to_non_nullable
          : arrivedAt as DateTime?,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime?,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
      cancelledAt: cancelledAt == const $CopyWithPlaceholder()
          ? _value.cancelledAt
          // ignore: cast_nullable_to_non_nullable
          : cancelledAt as DateTime?,
      cancelledBy: cancelledBy == const $CopyWithPlaceholder()
          ? _value.cancelledBy
          // ignore: cast_nullable_to_non_nullable
          : cancelledBy as DriverRideCancelledByEnum?,
      cancelReasonCode: cancelReasonCode == const $CopyWithPlaceholder()
          ? _value.cancelReasonCode
          // ignore: cast_nullable_to_non_nullable
          : cancelReasonCode as DriverRideCancelReasonCodeEnum?,
    );
  }
}

extension $DriverRideCopyWith on DriverRide {
  /// Returns a callable class that can be used as follows: `instanceOfDriverRide.copyWith(...)` or like so:`instanceOfDriverRide.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverRideCWProxy get copyWith => _$DriverRideCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRide _$DriverRideFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DriverRide',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'status',
        'pickup',
        'dropoff',
        'routeDistanceMeters',
        'student',
        'assignedAt',
      ],
    );
    final val = DriverRide(
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
      farePesewas: $checkedConvert('farePesewas', (v) => (v as num?)?.toInt()),
      pickupDistanceMeters: $checkedConvert(
        'pickupDistanceMeters',
        (v) => (v as num?)?.toInt(),
      ),
      pickupEtaSeconds: $checkedConvert(
        'pickupEtaSeconds',
        (v) => (v as num?)?.toInt(),
      ),
      routeDurationSeconds: $checkedConvert(
        'routeDurationSeconds',
        (v) => (v as num?)?.toInt(),
      ),
      student: $checkedConvert(
        'student',
        (v) => DriverRideStudent.fromJson(v as Map<String, dynamic>),
      ),
      assignedAt: $checkedConvert(
        'assignedAt',
        (v) => DateTime.parse(v as String),
      ),
      acknowledgedAt: $checkedConvert(
        'acknowledgedAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      noShowAvailableAt: $checkedConvert(
        'noShowAvailableAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      arrivedAt: $checkedConvert(
        'arrivedAt',
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
      cancelledAt: $checkedConvert(
        'cancelledAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      cancelledBy: $checkedConvert(
        'cancelledBy',
        (v) => $enumDecodeNullable(_$DriverRideCancelledByEnumEnumMap, v),
      ),
      cancelReasonCode: $checkedConvert(
        'cancelReasonCode',
        (v) => $enumDecodeNullable(_$DriverRideCancelReasonCodeEnumEnumMap, v),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$DriverRideToJson(DriverRide instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$RideStatusEnumMap[instance.status]!,
      'pickup': instance.pickup.toJson(),
      'dropoff': instance.dropoff.toJson(),
      'routeDistanceMeters': instance.routeDistanceMeters,
      'routePolyline': ?instance.routePolyline,
      'farePesewas': ?instance.farePesewas,
      'pickupDistanceMeters': ?instance.pickupDistanceMeters,
      'pickupEtaSeconds': ?instance.pickupEtaSeconds,
      'routeDurationSeconds': ?instance.routeDurationSeconds,
      'student': instance.student.toJson(),
      'assignedAt': instance.assignedAt.toIso8601String(),
      'acknowledgedAt': ?instance.acknowledgedAt?.toIso8601String(),
      'noShowAvailableAt': ?instance.noShowAvailableAt?.toIso8601String(),
      'arrivedAt': ?instance.arrivedAt?.toIso8601String(),
      'startedAt': ?instance.startedAt?.toIso8601String(),
      'completedAt': ?instance.completedAt?.toIso8601String(),
      'cancelledAt': ?instance.cancelledAt?.toIso8601String(),
      'cancelledBy': ?_$DriverRideCancelledByEnumEnumMap[instance.cancelledBy],
      'cancelReasonCode':
          ?_$DriverRideCancelReasonCodeEnumEnumMap[instance.cancelReasonCode],
    };

const _$RideStatusEnumMap = {
  RideStatus.searching: 'searching',
  RideStatus.assigned: 'assigned',
  RideStatus.driverArrived: 'driver_arrived',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};

const _$DriverRideCancelledByEnumEnumMap = {
  DriverRideCancelledByEnum.student: 'student',
  DriverRideCancelledByEnum.driver: 'driver',
  DriverRideCancelledByEnum.system: 'system',
  DriverRideCancelledByEnum.admin: 'admin',
};

const _$DriverRideCancelReasonCodeEnumEnumMap = {
  DriverRideCancelReasonCodeEnum.studentChangedMind: 'student_changed_mind',
  DriverRideCancelReasonCodeEnum.driverUnavailable: 'driver_unavailable',
  DriverRideCancelReasonCodeEnum.vehicleIssue: 'vehicle_issue',
  DriverRideCancelReasonCodeEnum.noDriverAvailable: 'no_driver_available',
  DriverRideCancelReasonCodeEnum.serviceIssue: 'service_issue',
  DriverRideCancelReasonCodeEnum.adminDecision: 'admin_decision',
  DriverRideCancelReasonCodeEnum.other: 'other',
  DriverRideCancelReasonCodeEnum.riderNoShow: 'rider_no_show',
};
