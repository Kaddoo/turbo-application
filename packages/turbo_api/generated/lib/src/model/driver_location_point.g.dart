// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_location_point.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverLocationPointCWProxy {
  DriverLocationPoint point(GeoPoint point);

  DriverLocationPoint recordedAt(DateTime recordedAt);

  DriverLocationPoint accuracyMeters(num? accuracyMeters);

  DriverLocationPoint headingDegrees(num? headingDegrees);

  DriverLocationPoint speedMps(num? speedMps);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverLocationPoint(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverLocationPoint(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverLocationPoint call({
    GeoPoint point,
    DateTime recordedAt,
    num? accuracyMeters,
    num? headingDegrees,
    num? speedMps,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverLocationPoint.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverLocationPoint.copyWith.fieldName(...)`
class _$DriverLocationPointCWProxyImpl implements _$DriverLocationPointCWProxy {
  const _$DriverLocationPointCWProxyImpl(this._value);

  final DriverLocationPoint _value;

  @override
  DriverLocationPoint point(GeoPoint point) => this(point: point);

  @override
  DriverLocationPoint recordedAt(DateTime recordedAt) =>
      this(recordedAt: recordedAt);

  @override
  DriverLocationPoint accuracyMeters(num? accuracyMeters) =>
      this(accuracyMeters: accuracyMeters);

  @override
  DriverLocationPoint headingDegrees(num? headingDegrees) =>
      this(headingDegrees: headingDegrees);

  @override
  DriverLocationPoint speedMps(num? speedMps) => this(speedMps: speedMps);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverLocationPoint(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverLocationPoint(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverLocationPoint call({
    Object? point = const $CopyWithPlaceholder(),
    Object? recordedAt = const $CopyWithPlaceholder(),
    Object? accuracyMeters = const $CopyWithPlaceholder(),
    Object? headingDegrees = const $CopyWithPlaceholder(),
    Object? speedMps = const $CopyWithPlaceholder(),
  }) {
    return DriverLocationPoint(
      point: point == const $CopyWithPlaceholder()
          ? _value.point
          // ignore: cast_nullable_to_non_nullable
          : point as GeoPoint,
      recordedAt: recordedAt == const $CopyWithPlaceholder()
          ? _value.recordedAt
          // ignore: cast_nullable_to_non_nullable
          : recordedAt as DateTime,
      accuracyMeters: accuracyMeters == const $CopyWithPlaceholder()
          ? _value.accuracyMeters
          // ignore: cast_nullable_to_non_nullable
          : accuracyMeters as num?,
      headingDegrees: headingDegrees == const $CopyWithPlaceholder()
          ? _value.headingDegrees
          // ignore: cast_nullable_to_non_nullable
          : headingDegrees as num?,
      speedMps: speedMps == const $CopyWithPlaceholder()
          ? _value.speedMps
          // ignore: cast_nullable_to_non_nullable
          : speedMps as num?,
    );
  }
}

extension $DriverLocationPointCopyWith on DriverLocationPoint {
  /// Returns a callable class that can be used as follows: `instanceOfDriverLocationPoint.copyWith(...)` or like so:`instanceOfDriverLocationPoint.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverLocationPointCWProxy get copyWith =>
      _$DriverLocationPointCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverLocationPoint _$DriverLocationPointFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverLocationPoint', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['point', 'recordedAt']);
      final val = DriverLocationPoint(
        point: $checkedConvert(
          'point',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        recordedAt: $checkedConvert(
          'recordedAt',
          (v) => DateTime.parse(v as String),
        ),
        accuracyMeters: $checkedConvert('accuracyMeters', (v) => v as num?),
        headingDegrees: $checkedConvert('headingDegrees', (v) => v as num?),
        speedMps: $checkedConvert('speedMps', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$DriverLocationPointToJson(
  DriverLocationPoint instance,
) => <String, dynamic>{
  'point': instance.point.toJson(),
  'recordedAt': instance.recordedAt.toIso8601String(),
  'accuracyMeters': ?instance.accuracyMeters,
  'headingDegrees': ?instance.headingDegrees,
  'speedMps': ?instance.speedMps,
};
