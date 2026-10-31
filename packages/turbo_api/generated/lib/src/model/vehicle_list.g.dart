// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VehicleListCWProxy {
  VehicleList data(List<Vehicle> data);

  VehicleList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehicleList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehicleList(...).copyWith(id: 12, name: "My name")
  /// ````
  VehicleList call({List<Vehicle> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVehicleList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVehicleList.copyWith.fieldName(...)`
class _$VehicleListCWProxyImpl implements _$VehicleListCWProxy {
  const _$VehicleListCWProxyImpl(this._value);

  final VehicleList _value;

  @override
  VehicleList data(List<Vehicle> data) => this(data: data);

  @override
  VehicleList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehicleList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehicleList(...).copyWith(id: 12, name: "My name")
  /// ````
  VehicleList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return VehicleList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Vehicle>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $VehicleListCopyWith on VehicleList {
  /// Returns a callable class that can be used as follows: `instanceOfVehicleList.copyWith(...)` or like so:`instanceOfVehicleList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VehicleListCWProxy get copyWith => _$VehicleListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleList _$VehicleListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VehicleList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = VehicleList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VehicleListToJson(VehicleList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
