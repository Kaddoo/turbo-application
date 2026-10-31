// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_run.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReconciliationRunCWProxy {
  ReconciliationRun statementUploadId(String statementUploadId);

  ReconciliationRun periodFrom(DateTime periodFrom);

  ReconciliationRun periodTo(DateTime periodTo);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationRun(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationRun(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationRun call({
    String statementUploadId,
    DateTime periodFrom,
    DateTime periodTo,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReconciliationRun.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReconciliationRun.copyWith.fieldName(...)`
class _$ReconciliationRunCWProxyImpl implements _$ReconciliationRunCWProxy {
  const _$ReconciliationRunCWProxyImpl(this._value);

  final ReconciliationRun _value;

  @override
  ReconciliationRun statementUploadId(String statementUploadId) =>
      this(statementUploadId: statementUploadId);

  @override
  ReconciliationRun periodFrom(DateTime periodFrom) =>
      this(periodFrom: periodFrom);

  @override
  ReconciliationRun periodTo(DateTime periodTo) => this(periodTo: periodTo);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationRun(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationRun(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationRun call({
    Object? statementUploadId = const $CopyWithPlaceholder(),
    Object? periodFrom = const $CopyWithPlaceholder(),
    Object? periodTo = const $CopyWithPlaceholder(),
  }) {
    return ReconciliationRun(
      statementUploadId: statementUploadId == const $CopyWithPlaceholder()
          ? _value.statementUploadId
          // ignore: cast_nullable_to_non_nullable
          : statementUploadId as String,
      periodFrom: periodFrom == const $CopyWithPlaceholder()
          ? _value.periodFrom
          // ignore: cast_nullable_to_non_nullable
          : periodFrom as DateTime,
      periodTo: periodTo == const $CopyWithPlaceholder()
          ? _value.periodTo
          // ignore: cast_nullable_to_non_nullable
          : periodTo as DateTime,
    );
  }
}

extension $ReconciliationRunCopyWith on ReconciliationRun {
  /// Returns a callable class that can be used as follows: `instanceOfReconciliationRun.copyWith(...)` or like so:`instanceOfReconciliationRun.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReconciliationRunCWProxy get copyWith =>
      _$ReconciliationRunCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconciliationRun _$ReconciliationRunFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReconciliationRun', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['statementUploadId', 'periodFrom', 'periodTo'],
  );
  final val = ReconciliationRun(
    statementUploadId: $checkedConvert('statementUploadId', (v) => v as String),
    periodFrom: $checkedConvert(
      'periodFrom',
      (v) => DateTime.parse(v as String),
    ),
    periodTo: $checkedConvert('periodTo', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ReconciliationRunToJson(ReconciliationRun instance) =>
    <String, dynamic>{
      'statementUploadId': instance.statementUploadId,
      'periodFrom': instance.periodFrom.toIso8601String(),
      'periodTo': instance.periodTo.toIso8601String(),
    };
