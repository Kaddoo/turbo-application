// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WalletCWProxy {
  Wallet balancePesewas(int balancePesewas);

  Wallet reservedPesewas(int reservedPesewas);

  Wallet availablePesewas(int availablePesewas);

  Wallet currency(WalletCurrencyEnum currency);

  Wallet owedPesewas(int? owedPesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Wallet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Wallet(...).copyWith(id: 12, name: "My name")
  /// ````
  Wallet call({
    int balancePesewas,
    int reservedPesewas,
    int availablePesewas,
    WalletCurrencyEnum currency,
    int? owedPesewas,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWallet.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWallet.copyWith.fieldName(...)`
class _$WalletCWProxyImpl implements _$WalletCWProxy {
  const _$WalletCWProxyImpl(this._value);

  final Wallet _value;

  @override
  Wallet balancePesewas(int balancePesewas) =>
      this(balancePesewas: balancePesewas);

  @override
  Wallet reservedPesewas(int reservedPesewas) =>
      this(reservedPesewas: reservedPesewas);

  @override
  Wallet availablePesewas(int availablePesewas) =>
      this(availablePesewas: availablePesewas);

  @override
  Wallet currency(WalletCurrencyEnum currency) => this(currency: currency);

  @override
  Wallet owedPesewas(int? owedPesewas) => this(owedPesewas: owedPesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Wallet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Wallet(...).copyWith(id: 12, name: "My name")
  /// ````
  Wallet call({
    Object? balancePesewas = const $CopyWithPlaceholder(),
    Object? reservedPesewas = const $CopyWithPlaceholder(),
    Object? availablePesewas = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? owedPesewas = const $CopyWithPlaceholder(),
  }) {
    return Wallet(
      balancePesewas: balancePesewas == const $CopyWithPlaceholder()
          ? _value.balancePesewas
          // ignore: cast_nullable_to_non_nullable
          : balancePesewas as int,
      reservedPesewas: reservedPesewas == const $CopyWithPlaceholder()
          ? _value.reservedPesewas
          // ignore: cast_nullable_to_non_nullable
          : reservedPesewas as int,
      availablePesewas: availablePesewas == const $CopyWithPlaceholder()
          ? _value.availablePesewas
          // ignore: cast_nullable_to_non_nullable
          : availablePesewas as int,
      currency: currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as WalletCurrencyEnum,
      owedPesewas: owedPesewas == const $CopyWithPlaceholder()
          ? _value.owedPesewas
          // ignore: cast_nullable_to_non_nullable
          : owedPesewas as int?,
    );
  }
}

extension $WalletCopyWith on Wallet {
  /// Returns a callable class that can be used as follows: `instanceOfWallet.copyWith(...)` or like so:`instanceOfWallet.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WalletCWProxy get copyWith => _$WalletCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Wallet',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'balancePesewas',
        'reservedPesewas',
        'availablePesewas',
        'currency',
      ],
    );
    final val = Wallet(
      balancePesewas: $checkedConvert(
        'balancePesewas',
        (v) => (v as num).toInt(),
      ),
      reservedPesewas: $checkedConvert(
        'reservedPesewas',
        (v) => (v as num).toInt(),
      ),
      availablePesewas: $checkedConvert(
        'availablePesewas',
        (v) => (v as num).toInt(),
      ),
      currency: $checkedConvert(
        'currency',
        (v) => $enumDecode(_$WalletCurrencyEnumEnumMap, v),
      ),
      owedPesewas: $checkedConvert('owedPesewas', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
);

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
  'balancePesewas': instance.balancePesewas,
  'reservedPesewas': instance.reservedPesewas,
  'availablePesewas': instance.availablePesewas,
  'currency': _$WalletCurrencyEnumEnumMap[instance.currency]!,
  'owedPesewas': ?instance.owedPesewas,
};

const _$WalletCurrencyEnumEnumMap = {WalletCurrencyEnum.GHS: 'GHS'};
