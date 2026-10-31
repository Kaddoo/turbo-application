// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_location.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverLocationCWProxy {
  DriverLocation point(GeoPoint point);

  DriverLocation headingDegrees(num? headingDegrees);

  DriverLocation speedMps(num? speedMps);

  DriverLocation recordedAt(DateTime recordedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverLocation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverLocation(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverLocation call({
    GeoPoint point,
    num? headingDegrees,
    num? speedMps,
    DateTime recordedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverLocation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverLocation.copyWith.fieldName(...)`
class _$DriverLocationCWProxyImpl implements _$DriverLocationCWProxy {
  const _$DriverLocationCWProxyImpl(this._value);

  final DriverLocation _value;

  @override
  DriverLocation point(GeoPoint point) => this(point: point);

  @override
  DriverLocation headingDegrees(num? headingDegrees) =>
      this(headingDegrees: headingDegrees);

  @override
  DriverLocation speedMps(num? speedMps) => this(speedMps: speedMps);

  @override
  DriverLocation recordedAt(DateTime recordedAt) =>
      this(recordedAt: recordedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverLocation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverLocation(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverLocation call({
    Object? point = const $CopyWithPlaceholder(),
    Object? headingDegrees = const $CopyWithPlaceholder(),
    Object? speedMps = const $CopyWithPlaceholder(),
    Object? recordedAt = const $CopyWithPlaceholder(),
  }) {
    return DriverLocation(
      point: point == const $CopyWithPlaceholder()
          ? _value.point
          // ignore: cast_nullable_to_non_nullable
          : point as GeoPoint,
      headingDegrees: headingDegrees == const $CopyWithPlaceholder()
          ? _value.headingDegrees
          // ignore: cast_nullable_to_non_nullable
          : headingDegrees as num?,
      speedMps: speedMps == const $CopyWithPlaceholder()
          ? _value.speedMps
          // ignore: cast_nullable_to_non_nullable
          : speedMps as num?,
      recordedAt: recordedAt == const $CopyWithPlaceholder()
          ? _value.recordedAt
          // ignore: cast_nullable_to_non_nullable
          : recordedAt as DateTime,
    );
  }
}

extension $DriverLocationCopyWith on DriverLocation {
  /// Returns a callable class that can be used as follows: `instanceOfDriverLocation.copyWith(...)` or like so:`instanceOfDriverLocation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverLocationCWProxy get copyWith => _$DriverLocationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverLocation _$DriverLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverLocation', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['point', 'recordedAt']);
      final val = DriverLocation(
        point: $checkedConvert(
          'point',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        headingDegrees: $checkedConvert('headingDegrees', (v) => v as num?),
        speedMps: $checkedConvert('speedMps', (v) => v as num?),
        recordedAt: $checkedConvert(
          'recordedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DriverLocationToJson(DriverLocation instance) =>
    <String, dynamic>{
      'point': instance.point.toJson(),
      'headingDegrees': ?instance.headingDegrees,
      'speedMps': ?instance.speedMps,
      'recordedAt': instance.recordedAt.toIso8601String(),
    };
