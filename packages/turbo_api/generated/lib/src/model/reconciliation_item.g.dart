// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReconciliationItemCWProxy {
  ReconciliationItem providerReference(String? providerReference);

  ReconciliationItem topupId(String? topupId);

  ReconciliationItem providerAmountPesewas(int? providerAmountPesewas);

  ReconciliationItem ourAmountPesewas(int? ourAmountPesewas);

  ReconciliationItem issue(ReconciliationItemIssueEnum issue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationItem call({
    String? providerReference,
    String? topupId,
    int? providerAmountPesewas,
    int? ourAmountPesewas,
    ReconciliationItemIssueEnum issue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReconciliationItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReconciliationItem.copyWith.fieldName(...)`
class _$ReconciliationItemCWProxyImpl implements _$ReconciliationItemCWProxy {
  const _$ReconciliationItemCWProxyImpl(this._value);

  final ReconciliationItem _value;

  @override
  ReconciliationItem providerReference(String? providerReference) =>
      this(providerReference: providerReference);

  @override
  ReconciliationItem topupId(String? topupId) => this(topupId: topupId);

  @override
  ReconciliationItem providerAmountPesewas(int? providerAmountPesewas) =>
      this(providerAmountPesewas: providerAmountPesewas);

  @override
  ReconciliationItem ourAmountPesewas(int? ourAmountPesewas) =>
      this(ourAmountPesewas: ourAmountPesewas);

  @override
  ReconciliationItem issue(ReconciliationItemIssueEnum issue) =>
      this(issue: issue);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReconciliationItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReconciliationItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ReconciliationItem call({
    Object? providerReference = const $CopyWithPlaceholder(),
    Object? topupId = const $CopyWithPlaceholder(),
    Object? providerAmountPesewas = const $CopyWithPlaceholder(),
    Object? ourAmountPesewas = const $CopyWithPlaceholder(),
    Object? issue = const $CopyWithPlaceholder(),
  }) {
    return ReconciliationItem(
      providerReference: providerReference == const $CopyWithPlaceholder()
          ? _value.providerReference
          // ignore: cast_nullable_to_non_nullable
          : providerReference as String?,
      topupId: topupId == const $CopyWithPlaceholder()
          ? _value.topupId
          // ignore: cast_nullable_to_non_nullable
          : topupId as String?,
      providerAmountPesewas:
          providerAmountPesewas == const $CopyWithPlaceholder()
          ? _value.providerAmountPesewas
          // ignore: cast_nullable_to_non_nullable
          : providerAmountPesewas as int?,
      ourAmountPesewas: ourAmountPesewas == const $CopyWithPlaceholder()
          ? _value.ourAmountPesewas
          // ignore: cast_nullable_to_non_nullable
          : ourAmountPesewas as int?,
      issue: issue == const $CopyWithPlaceholder()
          ? _value.issue
          // ignore: cast_nullable_to_non_nullable
          : issue as ReconciliationItemIssueEnum,
    );
  }
}

extension $ReconciliationItemCopyWith on ReconciliationItem {
  /// Returns a callable class that can be used as follows: `instanceOfReconciliationItem.copyWith(...)` or like so:`instanceOfReconciliationItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReconciliationItemCWProxy get copyWith =>
      _$ReconciliationItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconciliationItem _$ReconciliationItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReconciliationItem', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['issue']);
      final val = ReconciliationItem(
        providerReference: $checkedConvert(
          'providerReference',
          (v) => v as String?,
        ),
        topupId: $checkedConvert('topupId', (v) => v as String?),
        providerAmountPesewas: $checkedConvert(
          'providerAmountPesewas',
          (v) => (v as num?)?.toInt(),
        ),
        ourAmountPesewas: $checkedConvert(
          'ourAmountPesewas',
          (v) => (v as num?)?.toInt(),
        ),
        issue: $checkedConvert(
          'issue',
          (v) => $enumDecode(_$ReconciliationItemIssueEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReconciliationItemToJson(ReconciliationItem instance) =>
    <String, dynamic>{
      'providerReference': ?instance.providerReference,
      'topupId': ?instance.topupId,
      'providerAmountPesewas': ?instance.providerAmountPesewas,
      'ourAmountPesewas': ?instance.ourAmountPesewas,
      'issue': _$ReconciliationItemIssueEnumEnumMap[instance.issue]!,
    };

const _$ReconciliationItemIssueEnumEnumMap = {
  ReconciliationItemIssueEnum.missingHere: 'missing_here',
  ReconciliationItemIssueEnum.missingAtProvider: 'missing_at_provider',
  ReconciliationItemIssueEnum.amountMismatch: 'amount_mismatch',
  ReconciliationItemIssueEnum.statusMismatch: 'status_mismatch',
};
