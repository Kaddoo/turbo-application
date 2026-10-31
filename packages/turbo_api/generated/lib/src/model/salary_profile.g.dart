// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_profile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SalaryProfileCWProxy {
  SalaryProfile driverId(String driverId);

  SalaryProfile monthlySalaryPesewas(int monthlySalaryPesewas);

  SalaryProfile payPeriod(SalaryProfilePayPeriodEnum payPeriod);

  SalaryProfile updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryProfile call({
    String driverId,
    int monthlySalaryPesewas,
    SalaryProfilePayPeriodEnum payPeriod,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSalaryProfile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSalaryProfile.copyWith.fieldName(...)`
class _$SalaryProfileCWProxyImpl implements _$SalaryProfileCWProxy {
  const _$SalaryProfileCWProxyImpl(this._value);

  final SalaryProfile _value;

  @override
  SalaryProfile driverId(String driverId) => this(driverId: driverId);

  @override
  SalaryProfile monthlySalaryPesewas(int monthlySalaryPesewas) =>
      this(monthlySalaryPesewas: monthlySalaryPesewas);

  @override
  SalaryProfile payPeriod(SalaryProfilePayPeriodEnum payPeriod) =>
      this(payPeriod: payPeriod);

  @override
  SalaryProfile updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SalaryProfile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SalaryProfile(...).copyWith(id: 12, name: "My name")
  /// ````
  SalaryProfile call({
    Object? driverId = const $CopyWithPlaceholder(),
    Object? monthlySalaryPesewas = const $CopyWithPlaceholder(),
    Object? payPeriod = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return SalaryProfile(
      driverId: driverId == const $CopyWithPlaceholder()
          ? _value.driverId
          // ignore: cast_nullable_to_non_nullable
          : driverId as String,
      monthlySalaryPesewas: monthlySalaryPesewas == const $CopyWithPlaceholder()
          ? _value.monthlySalaryPesewas
          // ignore: cast_nullable_to_non_nullable
          : monthlySalaryPesewas as int,
      payPeriod: payPeriod == const $CopyWithPlaceholder()
          ? _value.payPeriod
          // ignore: cast_nullable_to_non_nullable
          : payPeriod as SalaryProfilePayPeriodEnum,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $SalaryProfileCopyWith on SalaryProfile {
  /// Returns a callable class that can be used as follows: `instanceOfSalaryProfile.copyWith(...)` or like so:`instanceOfSalaryProfile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SalaryProfileCWProxy get copyWith => _$SalaryProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryProfile _$SalaryProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SalaryProfile', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['driverId', 'monthlySalaryPesewas', 'payPeriod'],
      );
      final val = SalaryProfile(
        driverId: $checkedConvert('driverId', (v) => v as String),
        monthlySalaryPesewas: $checkedConvert(
          'monthlySalaryPesewas',
          (v) => (v as num).toInt(),
        ),
        payPeriod: $checkedConvert(
          'payPeriod',
          (v) => $enumDecode(_$SalaryProfilePayPeriodEnumEnumMap, v),
        ),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SalaryProfileToJson(SalaryProfile instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'monthlySalaryPesewas': instance.monthlySalaryPesewas,
      'payPeriod': _$SalaryProfilePayPeriodEnumEnumMap[instance.payPeriod]!,
      'updatedAt': ?instance.updatedAt?.toIso8601String(),
    };

const _$SalaryProfilePayPeriodEnumEnumMap = {
  SalaryProfilePayPeriodEnum.weekly: 'weekly',
  SalaryProfilePayPeriodEnum.biweekly: 'biweekly',
  SalaryProfilePayPeriodEnum.monthly: 'monthly',
};
