// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDetailCWProxy {
  VerificationDetail id(String id);

  VerificationDetail student(StudentSummary student);

  VerificationDetail status(VerificationStatus status);

  VerificationDetail submittedFullName(String submittedFullName);

  VerificationDetail studentIdNumber(String studentIdNumber);

  VerificationDetail submittedAt(DateTime submittedAt);

  VerificationDetail documents(List<VerificationDocument> documents);

  VerificationDetail history(List<VerificationDecisionRecord> history);

  VerificationDetail ghanaCardNumber(String ghanaCardNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDetail call({
    String id,
    StudentSummary student,
    VerificationStatus status,
    String submittedFullName,
    String studentIdNumber,
    DateTime submittedAt,
    List<VerificationDocument> documents,
    List<VerificationDecisionRecord> history,
    String ghanaCardNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDetail.copyWith.fieldName(...)`
class _$VerificationDetailCWProxyImpl implements _$VerificationDetailCWProxy {
  const _$VerificationDetailCWProxyImpl(this._value);

  final VerificationDetail _value;

  @override
  VerificationDetail id(String id) => this(id: id);

  @override
  VerificationDetail student(StudentSummary student) => this(student: student);

  @override
  VerificationDetail status(VerificationStatus status) => this(status: status);

  @override
  VerificationDetail submittedFullName(String submittedFullName) =>
      this(submittedFullName: submittedFullName);

  @override
  VerificationDetail studentIdNumber(String studentIdNumber) =>
      this(studentIdNumber: studentIdNumber);

  @override
  VerificationDetail submittedAt(DateTime submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  VerificationDetail documents(List<VerificationDocument> documents) =>
      this(documents: documents);

  @override
  VerificationDetail history(List<VerificationDecisionRecord> history) =>
      this(history: history);

  @override
  VerificationDetail ghanaCardNumber(String ghanaCardNumber) =>
      this(ghanaCardNumber: ghanaCardNumber);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDetail call({
    Object? id = const $CopyWithPlaceholder(),
    Object? student = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? submittedFullName = const $CopyWithPlaceholder(),
    Object? studentIdNumber = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? history = const $CopyWithPlaceholder(),
    Object? ghanaCardNumber = const $CopyWithPlaceholder(),
  }) {
    return VerificationDetail(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      student: student == const $CopyWithPlaceholder()
          ? _value.student
          // ignore: cast_nullable_to_non_nullable
          : student as StudentSummary,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VerificationStatus,
      submittedFullName: submittedFullName == const $CopyWithPlaceholder()
          ? _value.submittedFullName
          // ignore: cast_nullable_to_non_nullable
          : submittedFullName as String,
      studentIdNumber: studentIdNumber == const $CopyWithPlaceholder()
          ? _value.studentIdNumber
          // ignore: cast_nullable_to_non_nullable
          : studentIdNumber as String,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as DateTime,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<VerificationDocument>,
      history: history == const $CopyWithPlaceholder()
          ? _value.history
          // ignore: cast_nullable_to_non_nullable
          : history as List<VerificationDecisionRecord>,
      ghanaCardNumber: ghanaCardNumber == const $CopyWithPlaceholder()
          ? _value.ghanaCardNumber
          // ignore: cast_nullable_to_non_nullable
          : ghanaCardNumber as String,
    );
  }
}

extension $VerificationDetailCopyWith on VerificationDetail {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDetail.copyWith(...)` or like so:`instanceOfVerificationDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDetailCWProxy get copyWith =>
      _$VerificationDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDetail _$VerificationDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDetail', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'student',
      'status',
      'submittedFullName',
      'studentIdNumber',
      'submittedAt',
      'documents',
      'history',
      'ghanaCardNumber',
    ],
  );
  final val = VerificationDetail(
    id: $checkedConvert('id', (v) => v as String),
    student: $checkedConvert(
      'student',
      (v) => StudentSummary.fromJson(v as Map<String, dynamic>),
    ),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$VerificationStatusEnumMap, v),
    ),
    submittedFullName: $checkedConvert('submittedFullName', (v) => v as String),
    studentIdNumber: $checkedConvert('studentIdNumber', (v) => v as String),
    submittedAt: $checkedConvert(
      'submittedAt',
      (v) => DateTime.parse(v as String),
    ),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    history: $checkedConvert(
      'history',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                VerificationDecisionRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    ghanaCardNumber: $checkedConvert('ghanaCardNumber', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$VerificationDetailToJson(VerificationDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student': instance.student.toJson(),
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'submittedFullName': instance.submittedFullName,
      'studentIdNumber': instance.studentIdNumber,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'history': instance.history.map((e) => e.toJson()).toList(),
      'ghanaCardNumber': instance.ghanaCardNumber,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.notSubmitted: 'not_submitted',
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.needsAttention: 'needs_attention',
  VerificationStatus.rejected: 'rejected',
};
