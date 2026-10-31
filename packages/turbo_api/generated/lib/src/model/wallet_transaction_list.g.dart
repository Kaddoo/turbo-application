// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WalletTransactionListCWProxy {
  WalletTransactionList data(List<WalletTransaction> data);

  WalletTransactionList page(PageInfo page);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletTransactionList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletTransactionList(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletTransactionList call({List<WalletTransaction> data, PageInfo page});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWalletTransactionList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWalletTransactionList.copyWith.fieldName(...)`
class _$WalletTransactionListCWProxyImpl
    implements _$WalletTransactionListCWProxy {
  const _$WalletTransactionListCWProxyImpl(this._value);

  final WalletTransactionList _value;

  @override
  WalletTransactionList data(List<WalletTransaction> data) => this(data: data);

  @override
  WalletTransactionList page(PageInfo page) => this(page: page);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletTransactionList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletTransactionList(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletTransactionList call({
    Object? data = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
  }) {
    return WalletTransactionList(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<WalletTransaction>,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as PageInfo,
    );
  }
}

extension $WalletTransactionListCopyWith on WalletTransactionList {
  /// Returns a callable class that can be used as follows: `instanceOfWalletTransactionList.copyWith(...)` or like so:`instanceOfWalletTransactionList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WalletTransactionListCWProxy get copyWith =>
      _$WalletTransactionListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactionList _$WalletTransactionListFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WalletTransactionList', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data', 'page']);
  final val = WalletTransactionList(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    page: $checkedConvert(
      'page',
      (v) => PageInfo.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$WalletTransactionListToJson(
  WalletTransactionList instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'page': instance.page.toJson(),
};
