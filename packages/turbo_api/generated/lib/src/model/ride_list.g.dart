// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RideListCWProxy {
  RideList data(List<Ride> data);

  RideList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideList(...).copyWith(id: 12, name: "My name")
  /// ````
  RideList call({List<Ride> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRideList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRideList.copyWith.fieldName(...)`
class _$RideListCWProxyImpl implements _$RideListCWProxy {
  const _$RideListCWProxyImpl(this._value);

  final RideList _value;

  @override
  RideList data(List<Ride> data) => this(data: data);

  @override
  RideList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideList(...).copyWith(id: 12, name: "My name")
  /// ````
  RideList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return RideList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Ride>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $RideListCopyWith on RideList {
  /// Returns a callable class that can be used as follows: `instanceOfRideList.copyWith(...)` or like so:`instanceOfRideList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RideListCWProxy get copyWith => _$RideListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideList _$RideListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RideList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = RideList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Ride.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RideListToJson(RideList instance) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
