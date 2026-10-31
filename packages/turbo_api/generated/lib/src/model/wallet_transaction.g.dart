// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WalletTransactionCWProxy {
  WalletTransaction id(String id);

  WalletTransaction type(TransactionType type);

  WalletTransaction amountPesewas(int amountPesewas);

  WalletTransaction affectsBalance(bool affectsBalance);

  WalletTransaction balanceAfterPesewas(int balanceAfterPesewas);

  WalletTransaction rideId(String? rideId);

  WalletTransaction description(String description);

  WalletTransaction createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletTransaction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletTransaction(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletTransaction call({
    String id,
    TransactionType type,
    int amountPesewas,
    bool affectsBalance,
    int balanceAfterPesewas,
    String? rideId,
    String description,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWalletTransaction.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWalletTransaction.copyWith.fieldName(...)`
class _$WalletTransactionCWProxyImpl implements _$WalletTransactionCWProxy {
  const _$WalletTransactionCWProxyImpl(this._value);

  final WalletTransaction _value;

  @override
  WalletTransaction id(String id) => this(id: id);

  @override
  WalletTransaction type(TransactionType type) => this(type: type);

  @override
  WalletTransaction amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  WalletTransaction affectsBalance(bool affectsBalance) =>
      this(affectsBalance: affectsBalance);

  @override
  WalletTransaction balanceAfterPesewas(int balanceAfterPesewas) =>
      this(balanceAfterPesewas: balanceAfterPesewas);

  @override
  WalletTransaction rideId(String? rideId) => this(rideId: rideId);

  @override
  WalletTransaction description(String description) =>
      this(description: description);

  @override
  WalletTransaction createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletTransaction(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletTransaction(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletTransaction call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? affectsBalance = const $CopyWithPlaceholder(),
    Object? balanceAfterPesewas = const $CopyWithPlaceholder(),
    Object? rideId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return WalletTransaction(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as TransactionType,
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      affectsBalance: affectsBalance == const $CopyWithPlaceholder()
          ? _value.affectsBalance
          // ignore: cast_nullable_to_non_nullable
          : affectsBalance as bool,
      balanceAfterPesewas: balanceAfterPesewas == const $CopyWithPlaceholder()
          ? _value.balanceAfterPesewas
          // ignore: cast_nullable_to_non_nullable
          : balanceAfterPesewas as int,
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $WalletTransactionCopyWith on WalletTransaction {
  /// Returns a callable class that can be used as follows: `instanceOfWalletTransaction.copyWith(...)` or like so:`instanceOfWalletTransaction.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WalletTransactionCWProxy get copyWith =>
      _$WalletTransactionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransaction _$WalletTransactionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WalletTransaction', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'type',
      'amountPesewas',
      'affectsBalance',
      'balanceAfterPesewas',
      'description',
      'createdAt',
    ],
  );
  final val = WalletTransaction(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$TransactionTypeEnumMap, v),
    ),
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    affectsBalance: $checkedConvert('affectsBalance', (v) => v as bool),
    balanceAfterPesewas: $checkedConvert(
      'balanceAfterPesewas',
      (v) => (v as num).toInt(),
    ),
    rideId: $checkedConvert('rideId', (v) => v as String?),
    description: $checkedConvert('description', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$WalletTransactionToJson(WalletTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amountPesewas': instance.amountPesewas,
      'affectsBalance': instance.affectsBalance,
      'balanceAfterPesewas': instance.balanceAfterPesewas,
      'rideId': ?instance.rideId,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.topup: 'topup',
  TransactionType.rideHold: 'ride_hold',
  TransactionType.rideRelease: 'ride_release',
  TransactionType.rideCharge: 'ride_charge',
  TransactionType.refund: 'refund',
  TransactionType.adjustment: 'adjustment',
  TransactionType.providerReversal: 'provider_reversal',
};
