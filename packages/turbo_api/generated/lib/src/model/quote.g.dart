// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QuoteCWProxy {
  Quote eligible(bool eligible);

  Quote quoteId(String? quoteId);

  Quote reasons(List<IneligibilityReason> reasons);

  Quote routeDistanceMeters(int? routeDistanceMeters);

  Quote routeDurationSeconds(int? routeDurationSeconds);

  Quote farePesewas(int? farePesewas);

  Quote pickupEtaSeconds(int? pickupEtaSeconds);

  Quote expiresAt(DateTime? expiresAt);

  Quote wallet(QuoteWallet wallet);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Quote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Quote(...).copyWith(id: 12, name: "My name")
  /// ````
  Quote call({
    bool eligible,
    String? quoteId,
    List<IneligibilityReason> reasons,
    int? routeDistanceMeters,
    int? routeDurationSeconds,
    int? farePesewas,
    int? pickupEtaSeconds,
    DateTime? expiresAt,
    QuoteWallet wallet,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQuote.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQuote.copyWith.fieldName(...)`
class _$QuoteCWProxyImpl implements _$QuoteCWProxy {
  const _$QuoteCWProxyImpl(this._value);

  final Quote _value;

  @override
  Quote eligible(bool eligible) => this(eligible: eligible);

  @override
  Quote quoteId(String? quoteId) => this(quoteId: quoteId);

  @override
  Quote reasons(List<IneligibilityReason> reasons) => this(reasons: reasons);

  @override
  Quote routeDistanceMeters(int? routeDistanceMeters) =>
      this(routeDistanceMeters: routeDistanceMeters);

  @override
  Quote routeDurationSeconds(int? routeDurationSeconds) =>
      this(routeDurationSeconds: routeDurationSeconds);

  @override
  Quote farePesewas(int? farePesewas) => this(farePesewas: farePesewas);

  @override
  Quote pickupEtaSeconds(int? pickupEtaSeconds) =>
      this(pickupEtaSeconds: pickupEtaSeconds);

  @override
  Quote expiresAt(DateTime? expiresAt) => this(expiresAt: expiresAt);

  @override
  Quote wallet(QuoteWallet wallet) => this(wallet: wallet);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Quote(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Quote(...).copyWith(id: 12, name: "My name")
  /// ````
  Quote call({
    Object? eligible = const $CopyWithPlaceholder(),
    Object? quoteId = const $CopyWithPlaceholder(),
    Object? reasons = const $CopyWithPlaceholder(),
    Object? routeDistanceMeters = const $CopyWithPlaceholder(),
    Object? routeDurationSeconds = const $CopyWithPlaceholder(),
    Object? farePesewas = const $CopyWithPlaceholder(),
    Object? pickupEtaSeconds = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? wallet = const $CopyWithPlaceholder(),
  }) {
    return Quote(
      eligible: eligible == const $CopyWithPlaceholder()
          ? _value.eligible
          // ignore: cast_nullable_to_non_nullable
          : eligible as bool,
      quoteId: quoteId == const $CopyWithPlaceholder()
          ? _value.quoteId
          // ignore: cast_nullable_to_non_nullable
          : quoteId as String?,
      reasons: reasons == const $CopyWithPlaceholder()
          ? _value.reasons
          // ignore: cast_nullable_to_non_nullable
          : reasons as List<IneligibilityReason>,
      routeDistanceMeters: routeDistanceMeters == const $CopyWithPlaceholder()
          ? _value.routeDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : routeDistanceMeters as int?,
      routeDurationSeconds: routeDurationSeconds == const $CopyWithPlaceholder()
          ? _value.routeDurationSeconds
          // ignore: cast_nullable_to_non_nullable
          : routeDurationSeconds as int?,
      farePesewas: farePesewas == const $CopyWithPlaceholder()
          ? _value.farePesewas
          // ignore: cast_nullable_to_non_nullable
          : farePesewas as int?,
      pickupEtaSeconds: pickupEtaSeconds == const $CopyWithPlaceholder()
          ? _value.pickupEtaSeconds
          // ignore: cast_nullable_to_non_nullable
          : pickupEtaSeconds as int?,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime?,
      wallet: wallet == const $CopyWithPlaceholder()
          ? _value.wallet
          // ignore: cast_nullable_to_non_nullable
          : wallet as QuoteWallet,
    );
  }
}

extension $QuoteCopyWith on Quote {
  /// Returns a callable class that can be used as follows: `instanceOfQuote.copyWith(...)` or like so:`instanceOfQuote.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QuoteCWProxy get copyWith => _$QuoteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Quote',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['eligible', 'reasons', 'wallet']);
    final val = Quote(
      eligible: $checkedConvert('eligible', (v) => v as bool),
      quoteId: $checkedConvert('quoteId', (v) => v as String?),
      reasons: $checkedConvert(
        'reasons',
        (v) => (v as List<dynamic>)
            .map((e) => IneligibilityReason.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      routeDistanceMeters: $checkedConvert(
        'routeDistanceMeters',
        (v) => (v as num?)?.toInt(),
      ),
      routeDurationSeconds: $checkedConvert(
        'routeDurationSeconds',
        (v) => (v as num?)?.toInt(),
      ),
      farePesewas: $checkedConvert('farePesewas', (v) => (v as num?)?.toInt()),
      pickupEtaSeconds: $checkedConvert(
        'pickupEtaSeconds',
        (v) => (v as num?)?.toInt(),
      ),
      expiresAt: $checkedConvert(
        'expiresAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      wallet: $checkedConvert(
        'wallet',
        (v) => QuoteWallet.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
  'eligible': instance.eligible,
  'quoteId': ?instance.quoteId,
  'reasons': instance.reasons.map((e) => e.toJson()).toList(),
  'routeDistanceMeters': ?instance.routeDistanceMeters,
  'routeDurationSeconds': ?instance.routeDurationSeconds,
  'farePesewas': ?instance.farePesewas,
  'pickupEtaSeconds': ?instance.pickupEtaSeconds,
  'expiresAt': ?instance.expiresAt?.toIso8601String(),
  'wallet': instance.wallet.toJson(),
};
