// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_batch.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocationBatchCWProxy {
  LocationBatch points(List<DriverLocationPoint> points);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationBatch(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationBatch(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationBatch call({List<DriverLocationPoint> points});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocationBatch.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocationBatch.copyWith.fieldName(...)`
class _$LocationBatchCWProxyImpl implements _$LocationBatchCWProxy {
  const _$LocationBatchCWProxyImpl(this._value);

  final LocationBatch _value;

  @override
  LocationBatch points(List<DriverLocationPoint> points) =>
      this(points: points);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationBatch(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationBatch(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationBatch call({Object? points = const $CopyWithPlaceholder()}) {
    return LocationBatch(
      points: points == const $CopyWithPlaceholder()
          ? _value.points
          // ignore: cast_nullable_to_non_nullable
          : points as List<DriverLocationPoint>,
    );
  }
}

extension $LocationBatchCopyWith on LocationBatch {
  /// Returns a callable class that can be used as follows: `instanceOfLocationBatch.copyWith(...)` or like so:`instanceOfLocationBatch.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocationBatchCWProxy get copyWith => _$LocationBatchCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationBatch _$LocationBatchFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LocationBatch', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['points']);
      final val = LocationBatch(
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>)
              .map(
                (e) => DriverLocationPoint.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LocationBatchToJson(LocationBatch instance) =>
    <String, dynamic>{
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
