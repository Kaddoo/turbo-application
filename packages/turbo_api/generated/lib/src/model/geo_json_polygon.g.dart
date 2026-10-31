// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_json_polygon.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GeoJsonPolygonCWProxy {
  GeoJsonPolygon type(GeoJsonPolygonTypeEnum type);

  GeoJsonPolygon coordinates(List<List<List<num>>> coordinates);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GeoJsonPolygon(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GeoJsonPolygon(...).copyWith(id: 12, name: "My name")
  /// ````
  GeoJsonPolygon call({
    GeoJsonPolygonTypeEnum type,
    List<List<List<num>>> coordinates,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGeoJsonPolygon.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGeoJsonPolygon.copyWith.fieldName(...)`
class _$GeoJsonPolygonCWProxyImpl implements _$GeoJsonPolygonCWProxy {
  const _$GeoJsonPolygonCWProxyImpl(this._value);

  final GeoJsonPolygon _value;

  @override
  GeoJsonPolygon type(GeoJsonPolygonTypeEnum type) => this(type: type);

  @override
  GeoJsonPolygon coordinates(List<List<List<num>>> coordinates) =>
      this(coordinates: coordinates);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GeoJsonPolygon(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GeoJsonPolygon(...).copyWith(id: 12, name: "My name")
  /// ````
  GeoJsonPolygon call({
    Object? type = const $CopyWithPlaceholder(),
    Object? coordinates = const $CopyWithPlaceholder(),
  }) {
    return GeoJsonPolygon(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as GeoJsonPolygonTypeEnum,
      coordinates: coordinates == const $CopyWithPlaceholder()
          ? _value.coordinates
          // ignore: cast_nullable_to_non_nullable
          : coordinates as List<List<List<num>>>,
    );
  }
}

extension $GeoJsonPolygonCopyWith on GeoJsonPolygon {
  /// Returns a callable class that can be used as follows: `instanceOfGeoJsonPolygon.copyWith(...)` or like so:`instanceOfGeoJsonPolygon.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GeoJsonPolygonCWProxy get copyWith => _$GeoJsonPolygonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoJsonPolygon _$GeoJsonPolygonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GeoJsonPolygon', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type', 'coordinates']);
      final val = GeoJsonPolygon(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$GeoJsonPolygonTypeEnumEnumMap, v),
        ),
        coordinates: $checkedConvert(
          'coordinates',
          (v) => (v as List<dynamic>)
              .map(
                (e) => (e as List<dynamic>)
                    .map(
                      (e) => (e as List<dynamic>).map((e) => e as num).toList(),
                    )
                    .toList(),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GeoJsonPolygonToJson(GeoJsonPolygon instance) =>
    <String, dynamic>{
      'type': _$GeoJsonPolygonTypeEnumEnumMap[instance.type]!,
      'coordinates': instance.coordinates,
    };

const _$GeoJsonPolygonTypeEnumEnumMap = {
  GeoJsonPolygonTypeEnum.polygon: 'Polygon',
};
