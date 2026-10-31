// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_report.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReconciliationReportCWProxy {
  ReconciliationReport id(String id);

  ReconciliationReport periodFrom(DateTime periodFrom);

  ReconciliationReport periodTo(DateTime periodTo);

  ReconciliationReport matchedCount(int matchedCount);

  ReconciliationReport providerTotalPesewas(int providerTotalPesewas);

  ReconciliationReport ourTotalPesewas(int ourTotalPesewas);

  ReconciliationReport exceptions(List<ReconciliationItem> exceptions);

  ReconciliationReport createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationReport(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationReport call({
    String id,
    DateTime periodFrom,
    DateTime periodTo,
    int matchedCount,
    int providerTotalPesewas,
    int ourTotalPesewas,
    List<ReconciliationItem> exceptions,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReconciliationReport.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReconciliationReport.copyWith.fieldName(...)`
class _$ReconciliationReportCWProxyImpl
    implements _$ReconciliationReportCWProxy {
  const _$ReconciliationReportCWProxyImpl(this._value);

  final ReconciliationReport _value;

  @override
  ReconciliationReport id(String id) => this(id: id);

  @override
  ReconciliationReport periodFrom(DateTime periodFrom) =>
      this(periodFrom: periodFrom);

  @override
  ReconciliationReport periodTo(DateTime periodTo) => this(periodTo: periodTo);

  @override
  ReconciliationReport matchedCount(int matchedCount) =>
      this(matchedCount: matchedCount);

  @override
  ReconciliationReport providerTotalPesewas(int providerTotalPesewas) =>
      this(providerTotalPesewas: providerTotalPesewas);

  @override
  ReconciliationReport ourTotalPesewas(int ourTotalPesewas) =>
      this(ourTotalPesewas: ourTotalPesewas);

  @override
  ReconciliationReport exceptions(List<ReconciliationItem> exceptions) =>
      this(exceptions: exceptions);

  @override
  ReconciliationReport createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationReport(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationReport(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationReport call({
    Object? id = const $CopyWithPlaceholder(),
    Object? periodFrom = const $CopyWithPlaceholder(),
    Object? periodTo = const $CopyWithPlaceholder(),
    Object? matchedCount = const $CopyWithPlaceholder(),
    Object? providerTotalPesewas = const $CopyWithPlaceholder(),
    Object? ourTotalPesewas = const $CopyWithPlaceholder(),
    Object? exceptions = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return ReconciliationReport(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      periodFrom: periodFrom == const $CopyWithPlaceholder()
          ? _value.periodFrom
          // ignore: cast_nullable_to_non_nullable
          : periodFrom as DateTime,
      periodTo: periodTo == const $CopyWithPlaceholder()
          ? _value.periodTo
          // ignore: cast_nullable_to_non_nullable
          : periodTo as DateTime,
      matchedCount: matchedCount == const $CopyWithPlaceholder()
          ? _value.matchedCount
          // ignore: cast_nullable_to_non_nullable
          : matchedCount as int,
      providerTotalPesewas: providerTotalPesewas == const $CopyWithPlaceholder()
          ? _value.providerTotalPesewas
          // ignore: cast_nullable_to_non_nullable
          : providerTotalPesewas as int,
      ourTotalPesewas: ourTotalPesewas == const $CopyWithPlaceholder()
          ? _value.ourTotalPesewas
          // ignore: cast_nullable_to_non_nullable
          : ourTotalPesewas as int,
      exceptions: exceptions == const $CopyWithPlaceholder()
          ? _value.exceptions
          // ignore: cast_nullable_to_non_nullable
          : exceptions as List<ReconciliationItem>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $ReconciliationReportCopyWith on ReconciliationReport {
  /// Returns a callable class that can be used as follows: `instanceOfReconciliationReport.copyWith(...)` or like so:`instanceOfReconciliationReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReconciliationReportCWProxy get copyWith =>
      _$ReconciliationReportCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconciliationReport _$ReconciliationReportFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReconciliationReport', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'periodFrom',
      'periodTo',
      'matchedCount',
      'providerTotalPesewas',
      'ourTotalPesewas',
      'exceptions',
      'createdAt',
    ],
  );
  final val = ReconciliationReport(
    id: $checkedConvert('id', (v) => v as String),
    periodFrom: $checkedConvert(
      'periodFrom',
      (v) => DateTime.parse(v as String),
    ),
    periodTo: $checkedConvert('periodTo', (v) => DateTime.parse(v as String)),
    matchedCount: $checkedConvert('matchedCount', (v) => (v as num).toInt()),
    providerTotalPesewas: $checkedConvert(
      'providerTotalPesewas',
      (v) => (v as num).toInt(),
    ),
    ourTotalPesewas: $checkedConvert(
      'ourTotalPesewas',
      (v) => (v as num).toInt(),
    ),
    exceptions: $checkedConvert(
      'exceptions',
      (v) => (v as List<dynamic>)
          .map((e) => ReconciliationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ReconciliationReportToJson(
  ReconciliationReport instance,
) => <String, dynamic>{
  'id': instance.id,
  'periodFrom': instance.periodFrom.toIso8601String(),
  'periodTo': instance.periodTo.toIso8601String(),
  'matchedCount': instance.matchedCount,
  'providerTotalPesewas': instance.providerTotalPesewas,
  'ourTotalPesewas': instance.ourTotalPesewas,
  'exceptions': instance.exceptions.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};
