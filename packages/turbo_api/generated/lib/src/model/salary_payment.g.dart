// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_payment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SalaryPaymentCWProxy {
  SalaryPayment id(String id);

  SalaryPayment driverId(String driverId);

  SalaryPayment periodStart(DateTime periodStart);

  SalaryPayment periodEnd(DateTime periodEnd);

  SalaryPayment amountPesewas(int amountPesewas);

  SalaryPayment method(SalaryPaymentMethodEnum method);

  SalaryPayment reference(String? reference);

  SalaryPayment paidAt(DateTime paidAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPayment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPayment(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPayment call({
    String id,
    String driverId,
    DateTime periodStart,
    DateTime periodEnd,
    int amountPesewas,
    SalaryPaymentMethodEnum method,
    String? reference,
    DateTime paidAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSalaryPayment.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSalaryPayment.copyWith.fieldName(...)`
class _$SalaryPaymentCWProxyImpl implements _$SalaryPaymentCWProxy {
  const _$SalaryPaymentCWProxyImpl(this._value);

  final SalaryPayment _value;

  @override
  SalaryPayment id(String id) => this(id: id);

  @override
  SalaryPayment driverId(String driverId) => this(driverId: driverId);

  @override
  SalaryPayment periodStart(DateTime periodStart) =>
      this(periodStart: periodStart);

  @override
  SalaryPayment periodEnd(DateTime periodEnd) => this(periodEnd: periodEnd);

  @override
  SalaryPayment amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  SalaryPayment method(SalaryPaymentMethodEnum method) => this(method: method);

  @override
  SalaryPayment reference(String? reference) => this(reference: reference);

  @override
  SalaryPayment paidAt(DateTime paidAt) => this(paidAt: paidAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPayment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPayment(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPayment call({
    Object? id = const $CopyWithPlaceholder(),
    Object? driverId = const $CopyWithPlaceholder(),
    Object? periodStart = const $CopyWithPlaceholder(),
    Object? periodEnd = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? paidAt = const $CopyWithPlaceholder(),
  }) {
    return SalaryPayment(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      periodStart: periodStart == const $CopyWithPlaceholder()
          ? _value.periodStart
          // ignore: cast_nullable_to_non_nullable
          : periodStart as DateTime,
      periodEnd: periodEnd == const $CopyWithPlaceholder()
          ? _value.periodEnd
          // ignore: cast_nullable_to_non_nullable
          : periodEnd as DateTime,
      amountPesewas: amountPesewas == const $CopyWithPlaceholder()
          ? _value.amountPesewas
          // ignore: cast_nullable_to_non_nullable
          : amountPesewas as int,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as SalaryPaymentMethodEnum,
      reference: reference == const $CopyWithPlaceholder()
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as String?,
      paidAt: paidAt == const $CopyWithPlaceholder()
          ? _value.paidAt
          // ignore: cast_nullable_to_non_nullable
          : paidAt as DateTime,
    );
  }
}

extension $SalaryPaymentCopyWith on SalaryPayment {
  /// Returns a callable class that can be used as follows: `instanceOfSalaryPayment.copyWith(...)` or like so:`instanceOfSalaryPayment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SalaryPaymentCWProxy get copyWith => _$SalaryPaymentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryPayment _$SalaryPaymentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SalaryPayment', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'driverId',
      'periodStart',
      'periodEnd',
      'amountPesewas',
      'method',
      'paidAt',
    ],
  );
  final val = SalaryPayment(
    id: $checkedConvert('id', (v) => v as String),
    driverId: $checkedConvert('driverId', (v) => v as String),
    periodStart: $checkedConvert(
      'periodStart',
      (v) => DateTime.parse(v as String),
    ),
    periodEnd: $checkedConvert('periodEnd', (v) => DateTime.parse(v as String)),
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    method: $checkedConvert(
      'method',
      (v) => $enumDecode(_$SalaryPaymentMethodEnumEnumMap, v),
    ),
    reference: $checkedConvert('reference', (v) => v as String?),
    paidAt: $checkedConvert('paidAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$SalaryPaymentToJson(SalaryPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'amountPesewas': instance.amountPesewas,
      'method': _$SalaryPaymentMethodEnumEnumMap[instance.method]!,
      'reference': ?instance.reference,
      'paidAt': instance.paidAt.toIso8601String(),
    };

const _$SalaryPaymentMethodEnumEnumMap = {
  SalaryPaymentMethodEnum.bankTransfer: 'bank_transfer',
  SalaryPaymentMethodEnum.mobileMoney: 'mobile_money',
  SalaryPaymentMethodEnum.cash: 'cash',
};
