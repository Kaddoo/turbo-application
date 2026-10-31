// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_decision_record.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDecisionRecordCWProxy {
  VerificationDecisionRecord decision(
    VerificationDecisionRecordDecisionEnum decision,
  );

  VerificationDecisionRecord reasonCode(String? reasonCode);

  VerificationDecisionRecord decidedByStaffId(String decidedByStaffId);

  VerificationDecisionRecord decidedAt(DateTime decidedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDecisionRecord(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDecisionRecord(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDecisionRecord call({
    VerificationDecisionRecordDecisionEnum decision,
    String? reasonCode,
    String decidedByStaffId,
    DateTime decidedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDecisionRecord.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDecisionRecord.copyWith.fieldName(...)`
class _$VerificationDecisionRecordCWProxyImpl
    implements _$VerificationDecisionRecordCWProxy {
  const _$VerificationDecisionRecordCWProxyImpl(this._value);

  final VerificationDecisionRecord _value;

  @override
  VerificationDecisionRecord decision(
    VerificationDecisionRecordDecisionEnum decision,
  ) => this(decision: decision);

  @override
  VerificationDecisionRecord reasonCode(String? reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  VerificationDecisionRecord decidedByStaffId(String decidedByStaffId) =>
      this(decidedByStaffId: decidedByStaffId);

  @override
  VerificationDecisionRecord decidedAt(DateTime decidedAt) =>
      this(decidedAt: decidedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDecisionRecord(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDecisionRecord(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDecisionRecord call({
    Object? decision = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? decidedByStaffId = const $CopyWithPlaceholder(),
    Object? decidedAt = const $CopyWithPlaceholder(),
  }) {
    return VerificationDecisionRecord(
      decision: decision == const $CopyWithPlaceholder()
          ? _value.decision
          // ignore: cast_nullable_to_non_nullable
          : decision as VerificationDecisionRecordDecisionEnum,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as String?,
      decidedByStaffId: decidedByStaffId == const $CopyWithPlaceholder()
          ? _value.decidedByStaffId
          // ignore: cast_nullable_to_non_nullable
          : decidedByStaffId as String,
      decidedAt: decidedAt == const $CopyWithPlaceholder()
          ? _value.decidedAt
          // ignore: cast_nullable_to_non_nullable
          : decidedAt as DateTime,
    );
  }
}

extension $VerificationDecisionRecordCopyWith on VerificationDecisionRecord {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDecisionRecord.copyWith(...)` or like so:`instanceOfVerificationDecisionRecord.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDecisionRecordCWProxy get copyWith =>
      _$VerificationDecisionRecordCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDecisionRecord _$VerificationDecisionRecordFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDecisionRecord', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['decision', 'decidedByStaffId', 'decidedAt'],
  );
  final val = VerificationDecisionRecord(
    decision: $checkedConvert(
      'decision',
      (v) => $enumDecode(_$VerificationDecisionRecordDecisionEnumEnumMap, v),
    ),
    reasonCode: $checkedConvert('reasonCode', (v) => v as String?),
    decidedByStaffId: $checkedConvert('decidedByStaffId', (v) => v as String),
    decidedAt: $checkedConvert('decidedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$VerificationDecisionRecordToJson(
  VerificationDecisionRecord instance,
) => <String, dynamic>{
  'decision':
      _$VerificationDecisionRecordDecisionEnumEnumMap[instance.decision]!,
  'reasonCode': ?instance.reasonCode,
  'decidedByStaffId': instance.decidedByStaffId,
  'decidedAt': instance.decidedAt.toIso8601String(),
};

const _$VerificationDecisionRecordDecisionEnumEnumMap = {
  VerificationDecisionRecordDecisionEnum.approved: 'approved',
  VerificationDecisionRecordDecisionEnum.rejected: 'rejected',
  VerificationDecisionRecordDecisionEnum.needsAttention: 'needs_attention',
};
