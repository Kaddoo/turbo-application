// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationSummaryCWProxy {
  VerificationSummary id(String id);

  VerificationSummary student(VerificationSummaryStudent student);

  VerificationSummary status(VerificationStatus status);

  VerificationSummary submittedAt(DateTime submittedAt);

  VerificationSummary claimedBy(String? claimedBy);

  VerificationSummary claimExpiresAt(DateTime? claimExpiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummary call({
    String id,
    VerificationSummaryStudent student,
    VerificationStatus status,
    DateTime submittedAt,
    String? claimedBy,
    DateTime? claimExpiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationSummary.copyWith.fieldName(...)`
class _$VerificationSummaryCWProxyImpl implements _$VerificationSummaryCWProxy {
  const _$VerificationSummaryCWProxyImpl(this._value);

  final VerificationSummary _value;

  @override
  VerificationSummary id(String id) => this(id: id);

  @override
  VerificationSummary student(VerificationSummaryStudent student) =>
      this(student: student);

  @override
  VerificationSummary status(VerificationStatus status) => this(status: status);

  @override
  VerificationSummary submittedAt(DateTime submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  VerificationSummary claimedBy(String? claimedBy) =>
      this(claimedBy: claimedBy);

  @override
  VerificationSummary claimExpiresAt(DateTime? claimExpiresAt) =>
      this(claimExpiresAt: claimExpiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? student = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? claimedBy = const $CopyWithPlaceholder(),
    Object? claimExpiresAt = const $CopyWithPlaceholder(),
  }) {
    return VerificationSummary(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      student: student == const $CopyWithPlaceholder()
          ? _value.student
          // ignore: cast_nullable_to_non_nullable
          : student as VerificationSummaryStudent,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VerificationStatus,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as DateTime,
      claimedBy: claimedBy == const $CopyWithPlaceholder()
          ? _value.claimedBy
          // ignore: cast_nullable_to_non_nullable
          : claimedBy as String?,
      claimExpiresAt: claimExpiresAt == const $CopyWithPlaceholder()
          ? _value.claimExpiresAt
          // ignore: cast_nullable_to_non_nullable
          : claimExpiresAt as DateTime?,
    );
  }
}

extension $VerificationSummaryCopyWith on VerificationSummary {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationSummary.copyWith(...)` or like so:`instanceOfVerificationSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationSummaryCWProxy get copyWith =>
      _$VerificationSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationSummary _$VerificationSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VerificationSummary', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'student', 'status', 'submittedAt'],
      );
      final val = VerificationSummary(
        id: $checkedConvert('id', (v) => v as String),
        student: $checkedConvert(
          'student',
          (v) => VerificationSummaryStudent.fromJson(v as Map<String, dynamic>),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$VerificationStatusEnumMap, v),
        ),
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => DateTime.parse(v as String),
        ),
        claimedBy: $checkedConvert('claimedBy', (v) => v as String?),
        claimExpiresAt: $checkedConvert(
          'claimExpiresAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VerificationSummaryToJson(
  VerificationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'student': instance.student.toJson(),
  'status': _$VerificationStatusEnumMap[instance.status]!,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'claimedBy': ?instance.claimedBy,
  'claimExpiresAt': ?instance.claimExpiresAt?.toIso8601String(),
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.notSubmitted: 'not_submitted',
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.needsAttention: 'needs_attention',
  VerificationStatus.rejected: 'rejected',
};
