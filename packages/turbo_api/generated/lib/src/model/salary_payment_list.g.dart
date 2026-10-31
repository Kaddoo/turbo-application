// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_payment_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SalaryPaymentListCWProxy {
  SalaryPaymentList data(List<SalaryPayment> data);

  SalaryPaymentList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPaymentList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPaymentList(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPaymentList call({List<SalaryPayment> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSalaryPaymentList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSalaryPaymentList.copyWith.fieldName(...)`
class _$SalaryPaymentListCWProxyImpl implements _$SalaryPaymentListCWProxy {
  const _$SalaryPaymentListCWProxyImpl(this._value);

  final SalaryPaymentList _value;

  @override
  SalaryPaymentList data(List<SalaryPayment> data) => this(data: data);

  @override
  SalaryPaymentList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPaymentList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPaymentList(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPaymentList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return SalaryPaymentList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<SalaryPayment>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $SalaryPaymentListCopyWith on SalaryPaymentList {
  /// Returns a callable class that can be used as follows: `instanceOfSalaryPaymentList.copyWith(...)` or like so:`instanceOfSalaryPaymentList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SalaryPaymentListCWProxy get copyWith =>
      _$SalaryPaymentListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryPaymentList _$SalaryPaymentListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SalaryPaymentList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data', 'page']);
      final val = SalaryPaymentList(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => SalaryPayment.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        page: $checkedConvert(
          'page',
          (v) => PageInfo.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SalaryPaymentListToJson(SalaryPaymentList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'page': instance.page.toJson(),
    };
