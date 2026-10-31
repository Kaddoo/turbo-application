// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_profile_write.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SalaryProfileWriteCWProxy {
  SalaryProfileWrite monthlySalaryPesewas(int monthlySalaryPesewas);

  SalaryProfileWrite payPeriod(SalaryProfileWritePayPeriodEnum payPeriod);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryProfileWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryProfileWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryProfileWrite call({
    int monthlySalaryPesewas,
    SalaryProfileWritePayPeriodEnum payPeriod,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSalaryProfileWrite.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSalaryProfileWrite.copyWith.fieldName(...)`
class _$SalaryProfileWriteCWProxyImpl implements _$SalaryProfileWriteCWProxy {
  const _$SalaryProfileWriteCWProxyImpl(this._value);

  final SalaryProfileWrite _value;

  @override
  SalaryProfileWrite monthlySalaryPesewas(int monthlySalaryPesewas) =>
      this(monthlySalaryPesewas: monthlySalaryPesewas);

  @override
  SalaryProfileWrite payPeriod(SalaryProfileWritePayPeriodEnum payPeriod) =>
      this(payPeriod: payPeriod);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryProfileWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryProfileWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryProfileWrite call({
    Object? monthlySalaryPesewas = const $CopyWithPlaceholder(),
    Object? payPeriod = const $CopyWithPlaceholder(),
  }) {
    return SalaryProfileWrite(
      monthlySalaryPesewas: monthlySalaryPesewas == const $CopyWithPlaceholder()
          ? _value.monthlySalaryPesewas
          // ignore: cast_nullable_to_non_nullable
          : monthlySalaryPesewas as int,
      payPeriod: payPeriod == const $CopyWithPlaceholder()
          ? _value.payPeriod
          // ignore: cast_nullable_to_non_nullable
          : payPeriod as SalaryProfileWritePayPeriodEnum,
    );
  }
}

extension $SalaryProfileWriteCopyWith on SalaryProfileWrite {
  /// Returns a callable class that can be used as follows: `instanceOfSalaryProfileWrite.copyWith(...)` or like so:`instanceOfSalaryProfileWrite.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SalaryProfileWriteCWProxy get copyWith =>
      _$SalaryProfileWriteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryProfileWrite _$SalaryProfileWriteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SalaryProfileWrite', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['monthlySalaryPesewas', 'payPeriod'],
      );
      final val = SalaryProfileWrite(
        monthlySalaryPesewas: $checkedConvert(
          'monthlySalaryPesewas',
          (v) => (v as num).toInt(),
        ),
        payPeriod: $checkedConvert(
          'payPeriod',
          (v) => $enumDecode(_$SalaryProfileWritePayPeriodEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SalaryProfileWriteToJson(
  SalaryProfileWrite instance,
) => <String, dynamic>{
  'monthlySalaryPesewas': instance.monthlySalaryPesewas,
  'payPeriod': _$SalaryProfileWritePayPeriodEnumEnumMap[instance.payPeriod]!,
};

const _$SalaryProfileWritePayPeriodEnumEnumMap = {
  SalaryProfileWritePayPeriodEnum.weekly: 'weekly',
  SalaryProfileWritePayPeriodEnum.biweekly: 'biweekly',
  SalaryProfileWritePayPeriodEnum.monthly: 'monthly',
};
