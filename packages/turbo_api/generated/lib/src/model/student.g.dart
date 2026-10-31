// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StudentCWProxy {
  Student id(String id);

  Student phone(String phone);

  Student fullName(String? fullName);

  Student email(String? email);

  Student accountStatus(AccountStatus accountStatus);

  Student verificationStatus(VerificationStatus verificationStatus);

  Student createdAt(DateTime createdAt);

  Student termsAcceptedVersion(String? termsAcceptedVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Student(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Student(...).copyWith(id: 12, name: "My name")
  /// ````
  Student call({
    String id,
    String phone,
    String? fullName,
    String? email,
    AccountStatus accountStatus,
    VerificationStatus verificationStatus,
    DateTime createdAt,
    String? termsAcceptedVersion,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStudent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStudent.copyWith.fieldName(...)`
class _$StudentCWProxyImpl implements _$StudentCWProxy {
  const _$StudentCWProxyImpl(this._value);

  final Student _value;

  @override
  Student id(String id) => this(id: id);

  @override
  Student phone(String phone) => this(phone: phone);

  @override
  Student fullName(String? fullName) => this(fullName: fullName);

  @override
  Student email(String? email) => this(email: email);

  @override
  Student accountStatus(AccountStatus accountStatus) =>
      this(accountStatus: accountStatus);

  @override
  Student verificationStatus(VerificationStatus verificationStatus) =>
      this(verificationStatus: verificationStatus);

  @override
  Student createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Student termsAcceptedVersion(String? termsAcceptedVersion) =>
      this(termsAcceptedVersion: termsAcceptedVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Student(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Student(...).copyWith(id: 12, name: "My name")
  /// ````
  Student call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? accountStatus = const $CopyWithPlaceholder(),
    Object? verificationStatus = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? termsAcceptedVersion = const $CopyWithPlaceholder(),
  }) {
    return Student(
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
      termsAcceptedVersion: termsAcceptedVersion == const $CopyWithPlaceholder()
          ? _value.termsAcceptedVersion
          // ignore: cast_nullable_to_non_nullable
          : termsAcceptedVersion as String?,
    );
  }
}

extension $StudentCopyWith on Student {
  /// Returns a callable class that can be used as follows: `instanceOfStudent.copyWith(...)` or like so:`instanceOfStudent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StudentCWProxy get copyWith => _$StudentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Student', json, ($checkedConvert) {
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
      final val = Student(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        accountStatus: $checkedConvert(
          'accountStatus',
          (v) => $enumDecode(_$AccountStatusEnumMap, v),
        ),
        verificationStatus: $checkedConvert(
          'verificationStatus',
          (v) => $enumDecode(_$VerificationStatusEnumMap, v),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        termsAcceptedVersion: $checkedConvert(
          'termsAcceptedVersion',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'fullName': ?instance.fullName,
  'email': ?instance.email,
  'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
  'verificationStatus':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'termsAcceptedVersion': ?instance.termsAcceptedVersion,
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
