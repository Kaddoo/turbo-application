// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_payment_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SalaryPaymentCreateCWProxy {
  SalaryPaymentCreate driverId(String driverId);

  SalaryPaymentCreate periodStart(DateTime periodStart);

  SalaryPaymentCreate periodEnd(DateTime periodEnd);

  SalaryPaymentCreate amountPesewas(int amountPesewas);

  SalaryPaymentCreate method(SalaryPaymentCreateMethodEnum method);

  SalaryPaymentCreate reference(String? reference);

  SalaryPaymentCreate paidAt(DateTime paidAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPaymentCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPaymentCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPaymentCreate call({
    String driverId,
    DateTime periodStart,
    DateTime periodEnd,
    int amountPesewas,
    SalaryPaymentCreateMethodEnum method,
    String? reference,
    DateTime paidAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSalaryPaymentCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSalaryPaymentCreate.copyWith.fieldName(...)`
class _$SalaryPaymentCreateCWProxyImpl implements _$SalaryPaymentCreateCWProxy {
  const _$SalaryPaymentCreateCWProxyImpl(this._value);

  final SalaryPaymentCreate _value;

  @override
  SalaryPaymentCreate driverId(String driverId) => this(driverId: driverId);

  @override
  SalaryPaymentCreate periodStart(DateTime periodStart) =>
      this(periodStart: periodStart);

  @override
  SalaryPaymentCreate periodEnd(DateTime periodEnd) =>
      this(periodEnd: periodEnd);

  @override
  SalaryPaymentCreate amountPesewas(int amountPesewas) =>
      this(amountPesewas: amountPesewas);

  @override
  SalaryPaymentCreate method(SalaryPaymentCreateMethodEnum method) =>
      this(method: method);

  @override
  SalaryPaymentCreate reference(String? reference) =>
      this(reference: reference);

  @override
  SalaryPaymentCreate paidAt(DateTime paidAt) => this(paidAt: paidAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryPaymentCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryPaymentCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryPaymentCreate call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? periodStart = const $CopyWithPlaceholder(),
    Object? periodEnd = const $CopyWithPlaceholder(),
    Object? amountPesewas = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? paidAt = const $CopyWithPlaceholder(),
  }) {
    return SalaryPaymentCreate(
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
          : method as SalaryPaymentCreateMethodEnum,
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

extension $SalaryPaymentCreateCopyWith on SalaryPaymentCreate {
  /// Returns a callable class that can be used as follows: `instanceOfSalaryPaymentCreate.copyWith(...)` or like so:`instanceOfSalaryPaymentCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SalaryPaymentCreateCWProxy get copyWith =>
      _$SalaryPaymentCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryPaymentCreate _$SalaryPaymentCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SalaryPaymentCreate', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'driverId',
      'periodStart',
      'periodEnd',
      'amountPesewas',
      'method',
      'paidAt',
    ],
  );
  final val = SalaryPaymentCreate(
    driverId: $checkedConvert('driverId', (v) => v as String),
    periodStart: $checkedConvert(
      'periodStart',
      (v) => DateTime.parse(v as String),
    ),
    periodEnd: $checkedConvert('periodEnd', (v) => DateTime.parse(v as String)),
    amountPesewas: $checkedConvert('amountPesewas', (v) => (v as num).toInt()),
    method: $checkedConvert(
      'method',
      (v) => $enumDecode(_$SalaryPaymentCreateMethodEnumEnumMap, v),
    ),
    reference: $checkedConvert('reference', (v) => v as String?),
    paidAt: $checkedConvert('paidAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$SalaryPaymentCreateToJson(
  SalaryPaymentCreate instance,
) => <String, dynamic>{
  'driverId': instance.driverId,
  'periodStart': instance.periodStart.toIso8601String(),
  'periodEnd': instance.periodEnd.toIso8601String(),
  'amountPesewas': instance.amountPesewas,
  'method': _$SalaryPaymentCreateMethodEnumEnumMap[instance.method]!,
  'reference': ?instance.reference,
  'paidAt': instance.paidAt.toIso8601String(),
};

const _$SalaryPaymentCreateMethodEnumEnumMap = {
  SalaryPaymentCreateMethodEnum.bankTransfer: 'bank_transfer',
  SalaryPaymentCreateMethodEnum.mobileMoney: 'mobile_money',
  SalaryPaymentCreateMethodEnum.cash: 'cash',
};
