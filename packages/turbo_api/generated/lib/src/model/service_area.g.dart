// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceAreaCWProxy {
  ServiceArea version(int version);

  ServiceArea boundary(GeoJsonPolygon? boundary);

  ServiceArea pickupPoints(List<PickupPoint> pickupPoints);

  ServiceArea maxTripDistanceMeters(int maxTripDistanceMeters);

  ServiceArea fareBands(List<FareBand> fareBands);

  ServiceArea operatingHours(List<OperatingWindow>? operatingHours);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceArea(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceArea(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceArea call({
    int version,
    GeoJsonPolygon? boundary,
    List<PickupPoint> pickupPoints,
    int maxTripDistanceMeters,
    List<FareBand> fareBands,
    List<OperatingWindow>? operatingHours,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceArea.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceArea.copyWith.fieldName(...)`
class _$ServiceAreaCWProxyImpl implements _$ServiceAreaCWProxy {
  const _$ServiceAreaCWProxyImpl(this._value);

  final ServiceArea _value;

  @override
  ServiceArea version(int version) => this(version: version);

  @override
  ServiceArea boundary(GeoJsonPolygon? boundary) => this(boundary: boundary);

  @override
  ServiceArea pickupPoints(List<PickupPoint> pickupPoints) =>
      this(pickupPoints: pickupPoints);

  @override
  ServiceArea maxTripDistanceMeters(int maxTripDistanceMeters) =>
      this(maxTripDistanceMeters: maxTripDistanceMeters);

  @override
  ServiceArea fareBands(List<FareBand> fareBands) => this(fareBands: fareBands);

  @override
  ServiceArea operatingHours(List<OperatingWindow>? operatingHours) =>
      this(operatingHours: operatingHours);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceArea(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceArea(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceArea call({
    Object? version = const $CopyWithPlaceholder(),
    Object? boundary = const $CopyWithPlaceholder(),
    Object? pickupPoints = const $CopyWithPlaceholder(),
    Object? maxTripDistanceMeters = const $CopyWithPlaceholder(),
    Object? fareBands = const $CopyWithPlaceholder(),
    Object? operatingHours = const $CopyWithPlaceholder(),
  }) {
    return ServiceArea(
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      boundary: boundary == const $CopyWithPlaceholder()
          ? _value.boundary
          // ignore: cast_nullable_to_non_nullable
          : boundary as GeoJsonPolygon?,
      pickupPoints: pickupPoints == const $CopyWithPlaceholder()
          ? _value.pickupPoints
          // ignore: cast_nullable_to_non_nullable
          : pickupPoints as List<PickupPoint>,
      maxTripDistanceMeters:
          maxTripDistanceMeters == const $CopyWithPlaceholder()
          ? _value.maxTripDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : maxTripDistanceMeters as int,
      fareBands: fareBands == const $CopyWithPlaceholder()
          ? _value.fareBands
          // ignore: cast_nullable_to_non_nullable
          : fareBands as List<FareBand>,
      operatingHours: operatingHours == const $CopyWithPlaceholder()
          ? _value.operatingHours
          // ignore: cast_nullable_to_non_nullable
          : operatingHours as List<OperatingWindow>?,
    );
  }
}

extension $ServiceAreaCopyWith on ServiceArea {
  /// Returns a callable class that can be used as follows: `instanceOfServiceArea.copyWith(...)` or like so:`instanceOfServiceArea.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceAreaCWProxy get copyWith => _$ServiceAreaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceArea _$ServiceAreaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ServiceArea', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'version',
          'boundary',
          'pickupPoints',
          'maxTripDistanceMeters',
          'fareBands',
        ],
      );
      final val = ServiceArea(
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        boundary: $checkedConvert(
          'boundary',
          (v) => v == null
              ? null
              : GeoJsonPolygon.fromJson(v as Map<String, dynamic>),
        ),
        pickupPoints: $checkedConvert(
          'pickupPoints',
          (v) => (v as List<dynamic>)
              .map((e) => PickupPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        maxTripDistanceMeters: $checkedConvert(
          'maxTripDistanceMeters',
          (v) => (v as num).toInt(),
        ),
        fareBands: $checkedConvert(
          'fareBands',
          (v) => (v as List<dynamic>)
              .map((e) => FareBand.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        operatingHours: $checkedConvert(
          'operatingHours',
          (v) => (v as List<dynamic>?)
              ?.map((e) => OperatingWindow.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ServiceAreaToJson(
  ServiceArea instance,
) => <String, dynamic>{
  'version': instance.version,
  'boundary': instance.boundary?.toJson(),
  'pickupPoints': instance.pickupPoints.map((e) => e.toJson()).toList(),
  'maxTripDistanceMeters': instance.maxTripDistanceMeters,
  'fareBands': instance.fareBands.map((e) => e.toJson()).toList(),
  'operatingHours': ?instance.operatingHours?.map((e) => e.toJson()).toList(),
};
