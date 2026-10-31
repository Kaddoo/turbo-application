// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationStateCWProxy {
  VerificationState status(VerificationStatus status);

  VerificationState reasonCode(String? reasonCode);

  VerificationState message(String? message);

  VerificationState submittedAt(DateTime? submittedAt);

  VerificationState decidedAt(DateTime? decidedAt);

  VerificationState canResubmit(bool canResubmit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationState(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationState call({
    VerificationStatus status,
    String? reasonCode,
    String? message,
    DateTime? submittedAt,
    DateTime? decidedAt,
    bool canResubmit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationState.copyWith.fieldName(...)`
class _$VerificationStateCWProxyImpl implements _$VerificationStateCWProxy {
  const _$VerificationStateCWProxyImpl(this._value);

  final VerificationState _value;

  @override
  VerificationState status(VerificationStatus status) => this(status: status);

  @override
  VerificationState reasonCode(String? reasonCode) =>
      this(reasonCode: reasonCode);

  @override
  VerificationState message(String? message) => this(message: message);

  @override
  VerificationState submittedAt(DateTime? submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  VerificationState decidedAt(DateTime? decidedAt) =>
      this(decidedAt: decidedAt);

  @override
  VerificationState canResubmit(bool canResubmit) =>
      this(canResubmit: canResubmit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationState(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? reasonCode = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? decidedAt = const $CopyWithPlaceholder(),
    Object? canResubmit = const $CopyWithPlaceholder(),
  }) {
    return VerificationState(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VerificationStatus,
      reasonCode: reasonCode == const $CopyWithPlaceholder()
          ? _value.reasonCode
          // ignore: cast_nullable_to_non_nullable
          : reasonCode as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as DateTime?,
      decidedAt: decidedAt == const $CopyWithPlaceholder()
          ? _value.decidedAt
          // ignore: cast_nullable_to_non_nullable
          : decidedAt as DateTime?,
      canResubmit: canResubmit == const $CopyWithPlaceholder()
          ? _value.canResubmit
          // ignore: cast_nullable_to_non_nullable
          : canResubmit as bool,
    );
  }
}

extension $VerificationStateCopyWith on VerificationState {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationState.copyWith(...)` or like so:`instanceOfVerificationState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationStateCWProxy get copyWith =>
      _$VerificationStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationState _$VerificationStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VerificationState', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status', 'canResubmit']);
      final val = VerificationState(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$VerificationStatusEnumMap, v),
        ),
        reasonCode: $checkedConvert('reasonCode', (v) => v as String?),
        message: $checkedConvert('message', (v) => v as String?),
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        decidedAt: $checkedConvert(
          'decidedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        canResubmit: $checkedConvert('canResubmit', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$VerificationStateToJson(VerificationState instance) =>
    <String, dynamic>{
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'reasonCode': ?instance.reasonCode,
      'message': ?instance.message,
      'submittedAt': ?instance.submittedAt?.toIso8601String(),
      'decidedAt': ?instance.decidedAt?.toIso8601String(),
      'canResubmit': instance.canResubmit,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.notSubmitted: 'not_submitted',
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.needsAttention: 'needs_attention',
  VerificationStatus.rejected: 'rejected',
};
