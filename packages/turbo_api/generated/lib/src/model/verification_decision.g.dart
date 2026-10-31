// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_decision.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDecisionCWProxy {
  VerificationDecision decision(VerificationDecisionDecisionEnum decision);

  VerificationDecision reasonCode(String? reasonCode);

  VerificationDecision studentMessage(String? studentMessage);

  VerificationDecision internalNote(String? internalNote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDecision(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDecision(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDecision call({
    VerificationDecisionDecisionEnum decision,
    String? reasonCode,
    String? studentMessage,
    String? internalNote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDecision.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDecision.copyWith.fieldName(...)`
class _$VerificationDecisionCWProxyImpl
    implements _$VerificationDecisionCWProxy {
  const _$VerificationDecisionCWProxyImpl(this._value);

  final VerificationDecision _value;

  @override
  VerificationDecision decision(VerificationDecisionDecisionEnum decision) =>
      this(decision: decision);

  @override
  VerificationDecision reasonCode(String? reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  VerificationDecision studentMessage(String? studentMessage) =>
      this(studentMessage: studentMessage);

  @override
  VerificationDecision internalNote(String? internalNote) =>
      this(internalNote: internalNote);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDecision(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDecision(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDecision call({
    Object? decision = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? studentMessage = const $CopyWithPlaceholder(),
    Object? internalNote = const $CopyWithPlaceholder(),
  }) {
    return VerificationDecision(
      decision: decision == const $CopyWithPlaceholder()
          ? _value.decision
          // ignore: cast_nullable_to_non_nullable
          : decision as VerificationDecisionDecisionEnum,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as String?,
      studentMessage: studentMessage == const $CopyWithPlaceholder()
          ? _value.studentMessage
          // ignore: cast_nullable_to_non_nullable
          : studentMessage as String?,
      internalNote: internalNote == const $CopyWithPlaceholder()
          ? _value.internalNote
          // ignore: cast_nullable_to_non_nullable
          : internalNote as String?,
    );
  }
}

extension $VerificationDecisionCopyWith on VerificationDecision {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDecision.copyWith(...)` or like so:`instanceOfVerificationDecision.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDecisionCWProxy get copyWith =>
      _$VerificationDecisionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDecision _$VerificationDecisionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDecision', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['decision']);
  final val = VerificationDecision(
    decision: $checkedConvert(
      'decision',
      (v) => $enumDecode(_$VerificationDecisionDecisionEnumEnumMap, v),
    ),
    reasonCode: $checkedConvert('reasonCode', (v) => v as String?),
    studentMessage: $checkedConvert('studentMessage', (v) => v as String?),
    internalNote: $checkedConvert('internalNote', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$VerificationDecisionToJson(
  VerificationDecision instance,
) => <String, dynamic>{
  'decision': _$VerificationDecisionDecisionEnumEnumMap[instance.decision]!,
  'reasonCode': ?instance.reasonCode,
  'studentMessage': ?instance.studentMessage,
  'internalNote': ?instance.internalNote,
};

const _$VerificationDecisionDecisionEnumEnumMap = {
  VerificationDecisionDecisionEnum.approved: 'approved',
  VerificationDecisionDecisionEnum.rejected: 'rejected',
  VerificationDecisionDecisionEnum.needsAttention: 'needs_attention',
};
