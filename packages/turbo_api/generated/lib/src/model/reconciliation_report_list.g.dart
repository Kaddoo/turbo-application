// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_report_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReconciliationReportListCWProxy {
  ReconciliationReportList items(List<ReconciliationReport> items);

  ReconciliationReportList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationReportList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationReportList(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationReportList call({
    List<ReconciliationReport> items,
    PageInfo page,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReconciliationReportList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReconciliationReportList.copyWith.fieldName(...)`
class _$ReconciliationReportListCWProxyImpl
    implements _$ReconciliationReportListCWProxy {
  const _$ReconciliationReportListCWProxyImpl(this._value);

  final ReconciliationReportList _value;

  @override
  ReconciliationReportList items(List<ReconciliationReport> items) =>
      this(items: items);

  @override
  ReconciliationReportList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationReportList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationReportList(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationReportList call({
    Object? items = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return ReconciliationReportList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ReconciliationReport>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $ReconciliationReportListCopyWith on ReconciliationReportList {
  /// Returns a callable class that can be used as follows: `instanceOfReconciliationReportList.copyWith(...)` or like so:`instanceOfReconciliationReportList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReconciliationReportListCWProxy get copyWith =>
      _$ReconciliationReportListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconciliationReportList _$ReconciliationReportListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReconciliationReportList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'page']);
  final val = ReconciliationReportList(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => ReconciliationReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ReconciliationReportListToJson(
  ReconciliationReportList instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
