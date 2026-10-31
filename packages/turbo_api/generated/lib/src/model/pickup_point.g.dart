// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_point.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PickupPointCWProxy {
  PickupPoint id(String id);

  PickupPoint name(String name);

  PickupPoint point(GeoPoint point);

  PickupPoint isActive(bool isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PickupPoint(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PickupPoint(...).copyWith(id: 12, name: "My name")
  /// ````
  PickupPoint call({String id, String name, GeoPoint point, bool isActive});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPickupPoint.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPickupPoint.copyWith.fieldName(...)`
class _$PickupPointCWProxyImpl implements _$PickupPointCWProxy {
  const _$PickupPointCWProxyImpl(this._value);

  final PickupPoint _value;

  @override
  PickupPoint id(String id) => this(id: id);

  @override
  PickupPoint name(String name) => this(name: name);

  @override
  PickupPoint point(GeoPoint point) => this(point: point);

  @override
  PickupPoint isActive(bool isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PickupPoint(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PickupPoint(...).copyWith(id: 12, name: "My name")
  /// ````
  PickupPoint call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? point = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return PickupPoint(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
          : isActive as bool,
    );
  }
}

extension $PickupPointCopyWith on PickupPoint {
  /// Returns a callable class that can be used as follows: `instanceOfPickupPoint.copyWith(...)` or like so:`instanceOfPickupPoint.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PickupPointCWProxy get copyWith => _$PickupPointCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickupPoint _$PickupPointFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PickupPoint', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'point', 'isActive']);
      final val = PickupPoint(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        point: $checkedConvert(
          'point',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PickupPointToJson(PickupPoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'point': instance.point.toJson(),
      'isActive': instance.isActive,
    };
