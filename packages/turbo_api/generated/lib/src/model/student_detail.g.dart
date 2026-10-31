// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_detail.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StudentDetailCWProxy {
  StudentDetail id(String id);

  StudentDetail phone(String phone);

  StudentDetail fullName(String? fullName);

  StudentDetail email(String? email);

  StudentDetail studentIdNumber(String? studentIdNumber);

  StudentDetail accountStatus(AccountStatus accountStatus);

  StudentDetail verificationStatus(VerificationStatus verificationStatus);

  StudentDetail wallet(Wallet wallet);

  StudentDetail completedRides(int completedRides);

  StudentDetail createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentDetail call({
    String id,
    String phone,
    String? fullName,
    String? email,
    String? studentIdNumber,
    AccountStatus accountStatus,
    VerificationStatus verificationStatus,
    Wallet wallet,
    int completedRides,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudentDetail.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudentDetail.copyWith.fieldName(...)`
class _$StudentDetailCWProxyImpl implements _$StudentDetailCWProxy {
  const _$StudentDetailCWProxyImpl(this._value);

  final StudentDetail _value;

  @override
  StudentDetail id(String id) => this(id: id);

  @override
  StudentDetail phone(String phone) => this(phone: phone);

  @override
  StudentDetail fullName(String? fullName) => this(fullName: fullName);

  @override
  StudentDetail email(String? email) => this(email: email);

  @override
  StudentDetail studentIdNumber(String? studentIdNumber) =>
      this(studentIdNumber: studentIdNumber);

  @override
  StudentDetail accountStatus(AccountStatus accountStatus) =>
      this(accountStatus: accountStatus);

  @override
  StudentDetail verificationStatus(VerificationStatus verificationStatus) =>
      this(verificationStatus: verificationStatus);

  @override
  StudentDetail wallet(Wallet wallet) => this(wallet: wallet);

  @override
  StudentDetail completedRides(int completedRides) =>
      this(completedRides: completedRides);

  @override
  StudentDetail createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StudentDetail(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StudentDetail(...).copyWith(id: 12, name: "My name")
  /// ````
  StudentDetail call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? studentIdNumber = const $CopyWithPlaceholder(),
    Object? accountStatus = const $CopyWithPlaceholder(),
    Object? verificationStatus = const $CopyWithPlaceholder(),
    Object? wallet = const $CopyWithPlaceholder(),
    Object? completedRides = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return StudentDetail(
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
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      studentIdNumber: studentIdNumber == const $CopyWithPlaceholder()
          ? _value.studentIdNumber
          // ignore: cast_nullable_to_non_nullable
          : studentIdNumber as String?,
      accountStatus: accountStatus == const $CopyWithPlaceholder()
          ? _value.accountStatus
          // ignore: cast_nullable_to_non_nullable
          : accountStatus as AccountStatus,
      verificationStatus: verificationStatus == const $CopyWithPlaceholder()
          ? _value.verificationStatus
          // ignore: cast_nullable_to_non_nullable
          : verificationStatus as VerificationStatus,
      wallet: wallet == const $CopyWithPlaceholder()
          ? _value.wallet
          // ignore: cast_nullable_to_non_nullable
          : wallet as Wallet,
      completedRides: completedRides == const $CopyWithPlaceholder()
          ? _value.completedRides
          // ignore: cast_nullable_to_non_nullable
          : completedRides as int,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $StudentDetailCopyWith on StudentDetail {
  /// Returns a callable class that can be used as follows: `instanceOfStudentDetail.copyWith(...)` or like so:`instanceOfStudentDetail.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudentDetailCWProxy get copyWith => _$StudentDetailCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDetail _$StudentDetailFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StudentDetail', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'phone',
      'accountStatus',
      'verificationStatus',
      'wallet',
      'completedRides',
      'createdAt',
    ],
  );
  final val = StudentDetail(
    id: $checkedConvert('id', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String?),
    email: $checkedConvert('email', (v) => v as String?),
    studentIdNumber: $checkedConvert('studentIdNumber', (v) => v as String?),
    accountStatus: $checkedConvert(
      'accountStatus',
      (v) => $enumDecode(_$AccountStatusEnumMap, v),
    ),
    verificationStatus: $checkedConvert(
      'verificationStatus',
      (v) => $enumDecode(_$VerificationStatusEnumMap, v),
    ),
    wallet: $checkedConvert(
      'wallet',
      (v) => Wallet.fromJson(v as Map<String, dynamic>),
    ),
    completedRides: $checkedConvert(
      'completedRides',
      (v) => (v as num).toInt(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$StudentDetailToJson(StudentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'fullName': ?instance.fullName,
      'email': ?instance.email,
      'studentIdNumber': ?instance.studentIdNumber,
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'wallet': instance.wallet.toJson(),
      'completedRides': instance.completedRides,
      'createdAt': instance.createdAt.toIso8601String(),
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
