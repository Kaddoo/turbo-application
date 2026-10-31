// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ride_summary_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminRideSummaryListCWProxy {
  AdminRideSummaryList data(List<AdminRideSummary> data);

  AdminRideSummaryList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideSummaryList call({List<AdminRideSummary> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminRideSummaryList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminRideSummaryList.copyWith.fieldName(...)`
class _$AdminRideSummaryListCWProxyImpl
    implements _$AdminRideSummaryListCWProxy {
  const _$AdminRideSummaryListCWProxyImpl(this._value);

  final AdminRideSummaryList _value;

  @override
  AdminRideSummaryList data(List<AdminRideSummary> data) => this(data: data);

  @override
  AdminRideSummaryList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminRideSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminRideSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminRideSummaryList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return AdminRideSummaryList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<AdminRideSummary>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $AdminRideSummaryListCopyWith on AdminRideSummaryList {
  /// Returns a callable class that can be used as follows: `instanceOfAdminRideSummaryList.copyWith(...)` or like so:`instanceOfAdminRideSummaryList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminRideSummaryListCWProxy get copyWith =>
      _$AdminRideSummaryListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminRideSummaryList _$AdminRideSummaryListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminRideSummaryList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data', 'page']);
  final val = AdminRideSummaryList(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => AdminRideSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AdminRideSummaryListToJson(
  AdminRideSummaryList instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
