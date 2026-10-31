// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_submission.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationSubmissionCWProxy {
  VerificationSubmission fullName(String fullName);

  VerificationSubmission studentIdNumber(String studentIdNumber);

  VerificationSubmission ghanaCardFrontUploadId(String ghanaCardFrontUploadId);

  VerificationSubmission ghanaCardBackUploadId(String ghanaCardBackUploadId);

  VerificationSubmission studentIdUploadId(String studentIdUploadId);

  VerificationSubmission ghanaCardNumber(String ghanaCardNumber);

  VerificationSubmission selfieUploadId(String selfieUploadId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSubmission(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSubmission(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSubmission call({
    String fullName,
    String studentIdNumber,
    String ghanaCardFrontUploadId,
    String ghanaCardBackUploadId,
    String studentIdUploadId,
    String ghanaCardNumber,
    String selfieUploadId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationSubmission.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationSubmission.copyWith.fieldName(...)`
class _$VerificationSubmissionCWProxyImpl
    implements _$VerificationSubmissionCWProxy {
  const _$VerificationSubmissionCWProxyImpl(this._value);

  final VerificationSubmission _value;

  @override
  VerificationSubmission fullName(String fullName) => this(fullName: fullName);

  @override
  VerificationSubmission studentIdNumber(String studentIdNumber) =>
      this(studentIdNumber: studentIdNumber);

  @override
  VerificationSubmission ghanaCardFrontUploadId(
    String ghanaCardFrontUploadId,
  ) => this(ghanaCardFrontUploadId: ghanaCardFrontUploadId);

  @override
  VerificationSubmission ghanaCardBackUploadId(String ghanaCardBackUploadId) =>
      this(ghanaCardBackUploadId: ghanaCardBackUploadId);

  @override
  VerificationSubmission studentIdUploadId(String studentIdUploadId) =>
      this(studentIdUploadId: studentIdUploadId);

  @override
  VerificationSubmission ghanaCardNumber(String ghanaCardNumber) =>
      this(ghanaCardNumber: ghanaCardNumber);

  @override
  VerificationSubmission selfieUploadId(String selfieUploadId) =>
      this(selfieUploadId: selfieUploadId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationSubmission(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationSubmission(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationSubmission call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? studentIdNumber = const $CopyWithPlaceholder(),
    Object? ghanaCardFrontUploadId = const $CopyWithPlaceholder(),
    Object? ghanaCardBackUploadId = const $CopyWithPlaceholder(),
    Object? studentIdUploadId = const $CopyWithPlaceholder(),
    Object? ghanaCardNumber = const $CopyWithPlaceholder(),
    Object? selfieUploadId = const $CopyWithPlaceholder(),
  }) {
    return VerificationSubmission(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      studentIdNumber: studentIdNumber == const $CopyWithPlaceholder()
          ? _value.studentIdNumber
          // ignore: cast_nullable_to_non_nullable
          : studentIdNumber as String,
      ghanaCardFrontUploadId:
          ghanaCardFrontUploadId == const $CopyWithPlaceholder()
          ? _value.ghanaCardFrontUploadId
          // ignore: cast_nullable_to_non_nullable
          : ghanaCardFrontUploadId as String,
      ghanaCardBackUploadId:
          ghanaCardBackUploadId == const $CopyWithPlaceholder()
          ? _value.ghanaCardBackUploadId
          // ignore: cast_nullable_to_non_nullable
          : ghanaCardBackUploadId as String,
      studentIdUploadId: studentIdUploadId == const $CopyWithPlaceholder()
          ? _value.studentIdUploadId
          // ignore: cast_nullable_to_non_nullable
          : studentIdUploadId as String,
      ghanaCardNumber: ghanaCardNumber == const $CopyWithPlaceholder()
          ? _value.ghanaCardNumber
          // ignore: cast_nullable_to_non_nullable
          : ghanaCardNumber as String,
      selfieUploadId: selfieUploadId == const $CopyWithPlaceholder()
          ? _value.selfieUploadId
          // ignore: cast_nullable_to_non_nullable
          : selfieUploadId as String,
    );
  }
}

extension $VerificationSubmissionCopyWith on VerificationSubmission {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationSubmission.copyWith(...)` or like so:`instanceOfVerificationSubmission.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationSubmissionCWProxy get copyWith =>
      _$VerificationSubmissionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationSubmission _$VerificationSubmissionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationSubmission', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'fullName',
      'studentIdNumber',
      'ghanaCardFrontUploadId',
      'ghanaCardBackUploadId',
      'studentIdUploadId',
      'ghanaCardNumber',
      'selfieUploadId',
    ],
  );
  final val = VerificationSubmission(
    fullName: $checkedConvert('fullName', (v) => v as String),
    studentIdNumber: $checkedConvert('studentIdNumber', (v) => v as String),
    ghanaCardFrontUploadId: $checkedConvert(
      'ghanaCardFrontUploadId',
      (v) => v as String,
    ),
    ghanaCardBackUploadId: $checkedConvert(
      'ghanaCardBackUploadId',
      (v) => v as String,
    ),
    studentIdUploadId: $checkedConvert('studentIdUploadId', (v) => v as String),
    ghanaCardNumber: $checkedConvert('ghanaCardNumber', (v) => v as String),
    selfieUploadId: $checkedConvert('selfieUploadId', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$VerificationSubmissionToJson(
  VerificationSubmission instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'studentIdNumber': instance.studentIdNumber,
  'ghanaCardFrontUploadId': instance.ghanaCardFrontUploadId,
  'ghanaCardBackUploadId': instance.ghanaCardBackUploadId,
  'studentIdUploadId': instance.studentIdUploadId,
  'ghanaCardNumber': instance.ghanaCardNumber,
  'selfieUploadId': instance.selfieUploadId,
};
