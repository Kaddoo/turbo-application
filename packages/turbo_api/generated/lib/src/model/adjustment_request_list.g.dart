// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_request_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdjustmentRequestListCWProxy {
  AdjustmentRequestList items(List<AdjustmentRequest> items);

  AdjustmentRequestList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentRequestList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentRequestList(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentRequestList call({List<AdjustmentRequest> items, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdjustmentRequestList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdjustmentRequestList.copyWith.fieldName(...)`
class _$AdjustmentRequestListCWProxyImpl
    implements _$AdjustmentRequestListCWProxy {
  const _$AdjustmentRequestListCWProxyImpl(this._value);

  final AdjustmentRequestList _value;

  @override
  AdjustmentRequestList items(List<AdjustmentRequest> items) =>
      this(items: items);

  @override
  AdjustmentRequestList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentRequestList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentRequestList(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentRequestList call({
    Object? items = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return AdjustmentRequestList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdjustmentRequest>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $AdjustmentRequestListCopyWith on AdjustmentRequestList {
  /// Returns a callable class that can be used as follows: `instanceOfAdjustmentRequestList.copyWith(...)` or like so:`instanceOfAdjustmentRequestList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdjustmentRequestListCWProxy get copyWith =>
      _$AdjustmentRequestListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentRequestList _$AdjustmentRequestListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdjustmentRequestList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'page']);
  final val = AdjustmentRequestList(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AdjustmentRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AdjustmentRequestListToJson(
  AdjustmentRequestList instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
