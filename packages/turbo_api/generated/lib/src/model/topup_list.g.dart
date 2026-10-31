// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TopupListCWProxy {
  TopupList data(List<Topup> data);

  TopupList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupList(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupList call({List<Topup> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTopupList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTopupList.copyWith.fieldName(...)`
class _$TopupListCWProxyImpl implements _$TopupListCWProxy {
  const _$TopupListCWProxyImpl(this._value);

  final TopupList _value;

  @override
  TopupList data(List<Topup> data) => this(data: data);

  @override
  TopupList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TopupList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TopupList(...).copyWith(id: 12, name: "My name")
  /// ````
  TopupList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return TopupList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<Topup>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $TopupListCopyWith on TopupList {
  /// Returns a callable class that can be used as follows: `instanceOfTopupList.copyWith(...)` or like so:`instanceOfTopupList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TopupListCWProxy get copyWith => _$TopupListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupList _$TopupListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TopupList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = TopupList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Topup.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TopupListToJson(TopupList instance) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
