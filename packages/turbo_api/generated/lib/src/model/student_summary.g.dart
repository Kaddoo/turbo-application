// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StudentSummaryCWProxy {
  StudentSummary id(String id);

  StudentSummary phone(String phone);

  StudentSummary fullName(String? fullName);

  StudentSummary accountStatus(AccountStatus accountStatus);

  StudentSummary verificationStatus(VerificationStatus verificationStatus);

  StudentSummary createdAt(DateTime createdAt);

  StudentSummary noShowCount(int? noShowCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentSummary call({
    String id,
    String phone,
    String? fullName,
    AccountStatus accountStatus,
    VerificationStatus verificationStatus,
    DateTime createdAt,
    int? noShowCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudentSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudentSummary.copyWith.fieldName(...)`
class _$StudentSummaryCWProxyImpl implements _$StudentSummaryCWProxy {
  const _$StudentSummaryCWProxyImpl(this._value);

  final StudentSummary _value;

  @override
  StudentSummary id(String id) => this(id: id);

  @override
  StudentSummary phone(String phone) => this(phone: phone);

  @override
  StudentSummary fullName(String? fullName) => this(fullName: fullName);

  @override
  StudentSummary accountStatus(AccountStatus accountStatus) =>
      this(accountStatus: accountStatus);

  @override
  StudentSummary verificationStatus(VerificationStatus verificationStatus) =>
      this(verificationStatus: verificationStatus);

  @override
  StudentSummary createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  StudentSummary noShowCount(int? noShowCount) =>
      this(noShowCount: noShowCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? accountStatus = const $CopyWithPlaceholder(),
    Object? verificationStatus = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? noShowCount = const $CopyWithPlaceholder(),
  }) {
    return StudentSummary(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String?,
      accountStatus: accountStatus == const $CopyWithPlaceholder()
          ? _value.accountStatus
          // ignore: cast_nullable_to_non_nullable
          : accountStatus as AccountStatus,
      verificationStatus: verificationStatus == const $CopyWithPlaceholder()
          ? _value.verificationStatus
          // ignore: cast_nullable_to_non_nullable
          : verificationStatus as VerificationStatus,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      noShowCount: noShowCount == const $CopyWithPlaceholder()
          ? _value.noShowCount
          // ignore: cast_nullable_to_non_nullable
          : noShowCount as int?,
    );
  }
}

extension $StudentSummaryCopyWith on StudentSummary {
  /// Returns a callable class that can be used as follows: `instanceOfStudentSummary.copyWith(...)` or like so:`instanceOfStudentSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudentSummaryCWProxy get copyWith => _$StudentSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSummary _$StudentSummaryFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StudentSummary', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'phone',
      'accountStatus',
      'verificationStatus',
      'createdAt',
    ],
  );
  final val = StudentSummary(
    id: $checkedConvert('id', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String?),
    accountStatus: $checkedConvert(
      'accountStatus',
      (v) => $enumDecode(_$AccountStatusEnumMap, v),
    ),
    verificationStatus: $checkedConvert(
      'verificationStatus',
      (v) => $enumDecode(_$VerificationStatusEnumMap, v),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    noShowCount: $checkedConvert('noShowCount', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$StudentSummaryToJson(StudentSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'fullName': ?instance.fullName,
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'noShowCount': ?instance.noShowCount,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.notSubmitted: 'not_submitted',
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.needsAttention: 'needs_attention',
  VerificationStatus.rejected: 'rejected',
};
