// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_point_write.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PickupPointWriteCWProxy {
  PickupPointWrite name(String name);

  PickupPointWrite point(GeoPoint point);

  PickupPointWrite isActive(bool? isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PickupPointWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PickupPointWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  PickupPointWrite call({String name, GeoPoint point, bool? isActive});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPickupPointWrite.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPickupPointWrite.copyWith.fieldName(...)`
class _$PickupPointWriteCWProxyImpl implements _$PickupPointWriteCWProxy {
  const _$PickupPointWriteCWProxyImpl(this._value);

  final PickupPointWrite _value;

  @override
  PickupPointWrite name(String name) => this(name: name);

  @override
  PickupPointWrite point(GeoPoint point) => this(point: point);

  @override
  PickupPointWrite isActive(bool? isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PickupPointWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PickupPointWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  PickupPointWrite call({
    Object? name = const $CopyWithPlaceholder(),
    Object? point = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return PickupPointWrite(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      point: point == const $CopyWithPlaceholder()
          ? _value.point
          // ignore: cast_nullable_to_non_nullable
          : point as GeoPoint,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $PickupPointWriteCopyWith on PickupPointWrite {
  /// Returns a callable class that can be used as follows: `instanceOfPickupPointWrite.copyWith(...)` or like so:`instanceOfPickupPointWrite.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PickupPointWriteCWProxy get copyWith => _$PickupPointWriteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickupPointWrite _$PickupPointWriteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PickupPointWrite', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'point']);
      final val = PickupPointWrite(
        name: $checkedConvert('name', (v) => v as String),
        point: $checkedConvert(
          'point',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool? ?? true),
      );
      return val;
    });

Map<String, dynamic> _$PickupPointWriteToJson(PickupPointWrite instance) =>
    <String, dynamic>{
      'name': instance.name,
      'point': instance.point.toJson(),
      'isActive': ?instance.isActive,
    };
