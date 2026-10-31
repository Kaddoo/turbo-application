// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_adjustment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WalletAdjustmentCWProxy {
  WalletAdjustment amountPesewas(int amountPesewas);

  WalletAdjustment reasonCode(WalletAdjustmentReasonCodeEnum reasonCode);

  WalletAdjustment note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletAdjustment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletAdjustment(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletAdjustment call({
    int amountPesewas,
    WalletAdjustmentReasonCodeEnum reasonCode,
    String note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWalletAdjustment.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWalletAdjustment.copyWith.fieldName(...)`
class _$WalletAdjustmentCWProxyImpl implements _$WalletAdjustmentCWProxy {
  const _$WalletAdjustmentCWProxyImpl(this._value);

  final WalletAdjustment _value;

  @override
  WalletAdjustment amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  WalletAdjustment reasonCode(WalletAdjustmentReasonCodeEnum reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  WalletAdjustment note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WalletAdjustment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WalletAdjustment(...).copyWith(id: 12, name: "My name")
  /// ````
  WalletAdjustment call({
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return WalletAdjustment(
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as WalletAdjustmentReasonCodeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $WalletAdjustmentCopyWith on WalletAdjustment {
  /// Returns a callable class that can be used as follows: `instanceOfWalletAdjustment.copyWith(...)` or like so:`instanceOfWalletAdjustment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WalletAdjustmentCWProxy get copyWith => _$WalletAdjustmentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletAdjustment _$WalletAdjustmentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WalletAdjustment', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['amountPesewas', 'reasonCode', 'note']);
  final val = WalletAdjustment(
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    reasonCode: $checkedConvert(
      'reasonCode',
      (v) => $enumDecode(_$WalletAdjustmentReasonCodeEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$WalletAdjustmentToJson(
  WalletAdjustment instance,
) => <String, dynamic>{
  'amountPesewas': instance.amountPesewas,
  'reasonCode': _$WalletAdjustmentReasonCodeEnumEnumMap[instance.reasonCode]!,
  'note': instance.note,
};

const _$WalletAdjustmentReasonCodeEnumEnumMap = {
  WalletAdjustmentReasonCodeEnum.goodwill: 'goodwill',
  WalletAdjustmentReasonCodeEnum.duplicateCharge: 'duplicate_charge',
  WalletAdjustmentReasonCodeEnum.providerReconciliation:
      'provider_reconciliation',
  WalletAdjustmentReasonCodeEnum.correction: 'correction',
  WalletAdjustmentReasonCodeEnum.other: 'other',
};
