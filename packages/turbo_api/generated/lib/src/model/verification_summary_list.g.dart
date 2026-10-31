// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_summary_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationSummaryListCWProxy {
  VerificationSummaryList data(List<VerificationSummary> data);

  VerificationSummaryList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummaryList call({List<VerificationSummary> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationSummaryList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationSummaryList.copyWith.fieldName(...)`
class _$VerificationSummaryListCWProxyImpl
    implements _$VerificationSummaryListCWProxy {
  const _$VerificationSummaryListCWProxyImpl(this._value);

  final VerificationSummaryList _value;

  @override
  VerificationSummaryList data(List<VerificationSummary> data) =>
      this(data: data);

  @override
  VerificationSummaryList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummaryList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummaryList(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummaryList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return VerificationSummaryList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<VerificationSummary>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $VerificationSummaryListCopyWith on VerificationSummaryList {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationSummaryList.copyWith(...)` or like so:`instanceOfVerificationSummaryList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationSummaryListCWProxy get copyWith =>
      _$VerificationSummaryListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationSummaryList _$VerificationSummaryListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationSummaryList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data', 'page']);
  final val = VerificationSummaryList(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => VerificationSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$VerificationSummaryListToJson(
  VerificationSummaryList instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
