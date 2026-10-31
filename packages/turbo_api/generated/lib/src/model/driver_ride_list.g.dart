// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_ride_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverRideListCWProxy {
  DriverRideList data(List<DriverRide> data);

  DriverRideList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRideList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRideList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRideList call({List<DriverRide> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverRideList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverRideList.copyWith.fieldName(...)`
class _$DriverRideListCWProxyImpl implements _$DriverRideListCWProxy {
  const _$DriverRideListCWProxyImpl(this._value);

  final DriverRideList _value;

  @override
  DriverRideList data(List<DriverRide> data) => this(data: data);

  @override
  DriverRideList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverRideList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverRideList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverRideList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return DriverRideList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<DriverRide>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $DriverRideListCopyWith on DriverRideList {
  /// Returns a callable class that can be used as follows: `instanceOfDriverRideList.copyWith(...)` or like so:`instanceOfDriverRideList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverRideListCWProxy get copyWith => _$DriverRideListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRideList _$DriverRideListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverRideList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = DriverRideList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => DriverRide.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DriverRideListToJson(DriverRideList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
