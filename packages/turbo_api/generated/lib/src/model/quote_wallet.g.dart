// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_wallet.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuoteWalletCWProxy {
  QuoteWallet availablePesewas(int availablePesewas);

  QuoteWallet sufficient(bool sufficient);

  QuoteWallet shortfallPesewas(int shortfallPesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuoteWallet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuoteWallet(...).copyWith(id: 12, name: "My name")
  /// ````
  QuoteWallet call({
    int availablePesewas,
    bool sufficient,
    int shortfallPesewas,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuoteWallet.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuoteWallet.copyWith.fieldName(...)`
class _$QuoteWalletCWProxyImpl implements _$QuoteWalletCWProxy {
  const _$QuoteWalletCWProxyImpl(this._value);

  final QuoteWallet _value;

  @override
  QuoteWallet availablePesewas(int availablePesewas) =>
      this(availablePesewas: availablePesewas);

  @override
  QuoteWallet sufficient(bool sufficient) => this(sufficient: sufficient);

  @override
  QuoteWallet shortfallPesewas(int shortfallPesewas) =>
      this(shortfallPesewas: shortfallPesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QuoteWallet(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QuoteWallet(...).copyWith(id: 12, name: "My name")
  /// ````
  QuoteWallet call({
    Object? availablePesewas = const $CopyWithPlaceholder(),
    Object? sufficient = const $CopyWithPlaceholder(),
    Object? shortfallPesewas = const $CopyWithPlaceholder(),
  }) {
    return QuoteWallet(
      availablePesewas: availablePesewas == const $CopyWithPlaceholder()
          ? _value.availablePesewas
          // ignore: cast_nullable_to_non_nullable
          : availablePesewas as int,
      sufficient: sufficient == const $CopyWithPlaceholder()
          ? _value.sufficient
          // ignore: cast_nullable_to_non_nullable
          : sufficient as bool,
      shortfallPesewas: shortfallPesewas == const $CopyWithPlaceholder()
          ? _value.shortfallPesewas
          // ignore: cast_nullable_to_non_nullable
          : shortfallPesewas as int,
    );
  }
}

extension $QuoteWalletCopyWith on QuoteWallet {
  /// Returns a callable class that can be used as follows: `instanceOfQuoteWallet.copyWith(...)` or like so:`instanceOfQuoteWallet.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuoteWalletCWProxy get copyWith => _$QuoteWalletCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteWallet _$QuoteWalletFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QuoteWallet', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'availablePesewas',
          'sufficient',
          'shortfallPesewas',
        ],
      );
      final val = QuoteWallet(
        availablePesewas: $checkedConvert(
          'availablePesewas',
          (v) => (v as num).toInt(),
        ),
        sufficient: $checkedConvert('sufficient', (v) => v as bool),
        shortfallPesewas: $checkedConvert(
          'shortfallPesewas',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuoteWalletToJson(QuoteWallet instance) =>
    <String, dynamic>{
      'availablePesewas': instance.availablePesewas,
      'sufficient': instance.sufficient,
      'shortfallPesewas': instance.shortfallPesewas,
    };
