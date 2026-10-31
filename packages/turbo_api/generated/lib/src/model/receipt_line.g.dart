// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_line.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReceiptLineCWProxy {
  ReceiptLine label(String label);

  ReceiptLine amountPesewas(int amountPesewas);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceiptLine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceiptLine(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceiptLine call({String label, int amountPesewas});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReceiptLine.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReceiptLine.copyWith.fieldName(...)`
class _$ReceiptLineCWProxyImpl implements _$ReceiptLineCWProxy {
  const _$ReceiptLineCWProxyImpl(this._value);

  final ReceiptLine _value;

  @override
  ReceiptLine label(String label) => this(label: label);

  @override
  ReceiptLine amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceiptLine(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceiptLine(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceiptLine call({
    Object? label = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
  }) {
    return ReceiptLine(
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
    );
  }
}

extension $ReceiptLineCopyWith on ReceiptLine {
  /// Returns a callable class that can be used as follows: `instanceOfReceiptLine.copyWith(...)` or like so:`instanceOfReceiptLine.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReceiptLineCWProxy get copyWith => _$ReceiptLineCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptLine _$ReceiptLineFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReceiptLine', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['label', 'amountPesewas']);
      final val = ReceiptLine(
        label: $checkedConvert('label', (v) => v as String),
        amountPesewas: $checkedConvert(
          'amountPesewas',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReceiptLineToJson(ReceiptLine instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amountPesewas': instance.amountPesewas,
    };
