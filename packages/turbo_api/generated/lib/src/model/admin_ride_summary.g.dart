// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ride_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminRideSummaryCWProxy {
  AdminRideSummary id(String id);

  AdminRideSummary status(RideStatus status);

  AdminRideSummary studentId(String studentId);

  AdminRideSummary studentName(String? studentName);

  AdminRideSummary driverId(String? driverId);

  AdminRideSummary driverName(String? driverName);

  AdminRideSummary routeDistanceMeters(int routeDistanceMeters);

  AdminRideSummary farePesewas(int farePesewas);

  AdminRideSummary requestedAt(DateTime requestedAt);

  AdminRideSummary flags(List<RideFlag>? flags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideSummary call({
    String id,
    RideStatus status,
    String studentId,
    String? studentName,
    String? driverId,
    String? driverName,
    int routeDistanceMeters,
    int farePesewas,
    DateTime requestedAt,
    List<RideFlag>? flags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminRideSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminRideSummary.copyWith.fieldName(...)`
class _$AdminRideSummaryCWProxyImpl implements _$AdminRideSummaryCWProxy {
  const _$AdminRideSummaryCWProxyImpl(this._value);

  final AdminRideSummary _value;

  @override
  AdminRideSummary id(String id) => this(id: id);

  @override
  AdminRideSummary status(RideStatus status) => this(status: status);

  @override
  AdminRideSummary studentId(String studentId) => this(studentId: studentId);

  @override
  AdminRideSummary studentName(String? studentName) =>
      this(studentName: studentName);

  @override
  AdminRideSummary driverId(String? driverId) => this(driverId: driverId);

  @override
  AdminRideSummary driverName(String? driverName) =>
      this(driverName: driverName);

  @override
  AdminRideSummary routeDistanceMeters(int routeDistanceMeters) =>
      this(routeDistanceMeters: routeDistanceMeters);

  @override
  AdminRideSummary farePesewas(int farePesewas) =>
      this(farePesewas: farePesewas);

  @override
  AdminRideSummary requestedAt(DateTime requestedAt) =>
      this(requestedAt: requestedAt);

  @override
  AdminRideSummary flags(List<RideFlag>? flags) => this(flags: flags);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? studentId = const $CopyWithPlaceholder(),
    Object? studentName = const $CopyWithPlaceholder(),
    Object? driverId = const $CopyWithPlaceholder(),
    Object? driverName = const $CopyWithPlaceholder(),
    Object? routeDistanceMeters = const $CopyWithPlaceholder(),
    Object? farePesewas = const $CopyWithPlaceholder(),
    Object? requestedAt = const $CopyWithPlaceholder(),
    Object? flags = const $CopyWithPlaceholder(),
  }) {
    return AdminRideSummary(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RideStatus,
      studentId: studentId == const $CopyWithPlaceholder()
          ? _value.studentId
          // ignore: cast_nullable_to_non_nullable
          : studentId as String,
      studentName: studentName == const $CopyWithPlaceholder()
          ? _value.studentName
          // ignore: cast_nullable_to_non_nullable
          : studentName as String?,
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String?,
      driverName: driverName == const $CopyWithPlaceholder()
          ? _value.driverName
          // ignore: cast_nullable_to_non_nullable
          : driverName as String?,
      routeDistanceMeters: routeDistanceMeters == const $CopyWithPlaceholder()
          ? _value.routeDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : routeDistanceMeters as int,
      farePesewas: farePesewas == const $CopyWithPlaceholder()
          ? _value.farePesewas
          // ignore: cast_nullable_to_non_nullable
          : farePesewas as int,
      requestedAt: requestedAt == const $CopyWithPlaceholder()
          ? _value.requestedAt
          // ignore: cast_nullable_to_non_nullable
          : requestedAt as DateTime,
      flags: flags == const $CopyWithPlaceholder()
          ? _value.flags
          // ignore: cast_nullable_to_non_nullable
          : flags as List<RideFlag>?,
    );
  }
}

extension $AdminRideSummaryCopyWith on AdminRideSummary {
  /// Returns a callable class that can be used as follows: `instanceOfAdminRideSummary.copyWith(...)` or like so:`instanceOfAdminRideSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminRideSummaryCWProxy get copyWith => _$AdminRideSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRideSummary _$AdminRideSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminRideSummary', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'status',
          'studentId',
          'routeDistanceMeters',
          'farePesewas',
          'requestedAt',
        ],
      );
      final val = AdminRideSummary(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$RideStatusEnumMap, v),
        ),
        studentId: $checkedConvert('studentId', (v) => v as String),
        studentName: $checkedConvert('studentName', (v) => v as String?),
        driverId: $checkedConvert('driverId', (v) => v as String?),
        driverName: $checkedConvert('driverName', (v) => v as String?),
        routeDistanceMeters: $checkedConvert(
          'routeDistanceMeters',
          (v) => (v as num).toInt(),
        ),
        farePesewas: $checkedConvert('farePesewas', (v) => (v as num).toInt()),
        requestedAt: $checkedConvert(
          'requestedAt',
          (v) => DateTime.parse(v as String),
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

Map<String, dynamic> _$AdminRideSummaryToJson(AdminRideSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$RideStatusEnumMap[instance.status]!,
      'studentId': instance.studentId,
      'studentName': ?instance.studentName,
      'driverId': ?instance.driverId,
      'driverName': ?instance.driverName,
      'routeDistanceMeters': instance.routeDistanceMeters,
      'farePesewas': instance.farePesewas,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'flags': ?instance.flags?.map((e) => _$RideFlagEnumMap[e]!).toList(),
    };

const _$RideStatusEnumMap = {
  RideStatus.searching: 'searching',
  RideStatus.assigned: 'assigned',
  RideStatus.driverArrived: 'driver_arrived',
  RideStatus.inProgress: 'in_progress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};

const _$RideFlagEnumMap = {
  RideFlag.driverUnreachable: 'driver_unreachable',
  RideFlag.overdue: 'overdue',
  RideFlag.completedFarFromDestination: 'completed_far_from_destination',
  RideFlag.completedTooFast: 'completed_too_fast',
};
