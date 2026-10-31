// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocationCWProxy {
  Location point(GeoPoint point);

  Location label(String? label);

  Location pickupPointId(String? pickupPointId);

  Location landmark(String? landmark);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Location(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Location(...).copyWith(id: 12, name: "My name")
  /// ````
  Location call({
    GeoPoint point,
    String? label,
    String? pickupPointId,
    String? landmark,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocation.copyWith.fieldName(...)`
class _$LocationCWProxyImpl implements _$LocationCWProxy {
  const _$LocationCWProxyImpl(this._value);

  final Location _value;

  @override
  Location point(GeoPoint point) => this(point: point);

  @override
  Location label(String? label) => this(label: label);

  @override
  Location pickupPointId(String? pickupPointId) =>
      this(pickupPointId: pickupPointId);

  @override
  Location landmark(String? landmark) => this(landmark: landmark);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Location(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Location(...).copyWith(id: 12, name: "My name")
  /// ````
  Location call({
    Object? point = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? pickupPointId = const $CopyWithPlaceholder(),
    Object? landmark = const $CopyWithPlaceholder(),
  }) {
    return Location(
      point: point == const $CopyWithPlaceholder()
          ? _value.point
          // ignore: cast_nullable_to_non_nullable
          : point as GeoPoint,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
      pickupPointId: pickupPointId == const $CopyWithPlaceholder()
          ? _value.pickupPointId
          // ignore: cast_nullable_to_non_nullable
          : pickupPointId as String?,
      landmark: landmark == const $CopyWithPlaceholder()
          ? _value.landmark
          // ignore: cast_nullable_to_non_nullable
          : landmark as String?,
    );
  }
}

extension $LocationCopyWith on Location {
  /// Returns a callable class that can be used as follows: `instanceOfLocation.copyWith(...)` or like so:`instanceOfLocation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocationCWProxy get copyWith => _$LocationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Location', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['point']);
      final val = Location(
        point: $checkedConvert(
          'point',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        label: $checkedConvert('label', (v) => v as String?),
        pickupPointId: $checkedConvert('pickupPointId', (v) => v as String?),
        landmark: $checkedConvert('landmark', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'point': instance.point.toJson(),
  'label': ?instance.label,
  'pickupPointId': ?instance.pickupPointId,
  'landmark': ?instance.landmark,
};
