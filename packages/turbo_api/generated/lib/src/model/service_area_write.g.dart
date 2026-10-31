// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area_write.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceAreaWriteCWProxy {
  ServiceAreaWrite boundary(GeoJsonPolygon boundary);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaWrite call({GeoJsonPolygon boundary});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceAreaWrite.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceAreaWrite.copyWith.fieldName(...)`
class _$ServiceAreaWriteCWProxyImpl implements _$ServiceAreaWriteCWProxy {
  const _$ServiceAreaWriteCWProxyImpl(this._value);

  final ServiceAreaWrite _value;

  @override
  ServiceAreaWrite boundary(GeoJsonPolygon boundary) =>
      this(boundary: boundary);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaWrite call({Object? boundary = const $CopyWithPlaceholder()}) {
    return ServiceAreaWrite(
      boundary: boundary == const $CopyWithPlaceholder()
          ? _value.boundary
          // ignore: cast_nullable_to_non_nullable
          : boundary as GeoJsonPolygon,
    );
  }
}

extension $ServiceAreaWriteCopyWith on ServiceAreaWrite {
  /// Returns a callable class that can be used as follows: `instanceOfServiceAreaWrite.copyWith(...)` or like so:`instanceOfServiceAreaWrite.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceAreaWriteCWProxy get copyWith => _$ServiceAreaWriteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAreaWrite _$ServiceAreaWriteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ServiceAreaWrite', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['boundary']);
      final val = ServiceAreaWrite(
        boundary: $checkedConvert(
          'boundary',
          (v) => GeoJsonPolygon.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ServiceAreaWriteToJson(ServiceAreaWrite instance) =>
    <String, dynamic>{'boundary': instance.boundary.toJson()};
