// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_detail_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverDetailListCWProxy {
  DriverDetailList data(List<DriverDetail> data);

  DriverDetailList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDetailList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDetailList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDetailList call({List<DriverDetail> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverDetailList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverDetailList.copyWith.fieldName(...)`
class _$DriverDetailListCWProxyImpl implements _$DriverDetailListCWProxy {
  const _$DriverDetailListCWProxyImpl(this._value);

  final DriverDetailList _value;

  @override
  DriverDetailList data(List<DriverDetail> data) => this(data: data);

  @override
  DriverDetailList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverDetailList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverDetailList(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverDetailList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return DriverDetailList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<DriverDetail>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $DriverDetailListCopyWith on DriverDetailList {
  /// Returns a callable class that can be used as follows: `instanceOfDriverDetailList.copyWith(...)` or like so:`instanceOfDriverDetailList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverDetailListCWProxy get copyWith => _$DriverDetailListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverDetailList _$DriverDetailListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverDetailList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = DriverDetailList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => DriverDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DriverDetailListToJson(DriverDetailList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
