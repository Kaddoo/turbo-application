// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUserCWProxy {
  StaffUser id(String id);

  StaffUser email(String email);

  StaffUser fullName(String fullName);

  StaffUser staffRole(StaffRole staffRole);

  StaffUser isActive(bool isActive);

  StaffUser mfaEnrolled(bool mfaEnrolled);

  StaffUser lastLoginAt(DateTime? lastLoginAt);

  StaffUser lockedUntil(DateTime? lockedUntil);

  StaffUser invitePending(bool? invitePending);

  StaffUser adjustmentApprovalThresholdPesewas(
    int? adjustmentApprovalThresholdPesewas,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUser(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUser call({
    String id,
    String email,
    String fullName,
    StaffRole staffRole,
    bool isActive,
    bool mfaEnrolled,
    DateTime? lastLoginAt,
    DateTime? lockedUntil,
    bool? invitePending,
    int? adjustmentApprovalThresholdPesewas,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUser.copyWith.fieldName(...)`
class _$StaffUserCWProxyImpl implements _$StaffUserCWProxy {
  const _$StaffUserCWProxyImpl(this._value);

  final StaffUser _value;

  @override
  StaffUser id(String id) => this(id: id);

  @override
  StaffUser email(String email) => this(email: email);

  @override
  StaffUser fullName(String fullName) => this(fullName: fullName);

  @override
  StaffUser staffRole(StaffRole staffRole) => this(staffRole: staffRole);

  @override
  StaffUser isActive(bool isActive) => this(isActive: isActive);

  @override
  StaffUser mfaEnrolled(bool mfaEnrolled) => this(mfaEnrolled: mfaEnrolled);

  @override
  StaffUser lastLoginAt(DateTime? lastLoginAt) =>
      this(lastLoginAt: lastLoginAt);

  @override
  StaffUser lockedUntil(DateTime? lockedUntil) =>
      this(lockedUntil: lockedUntil);

  @override
  StaffUser invitePending(bool? invitePending) =>
      this(invitePending: invitePending);

  @override
  StaffUser adjustmentApprovalThresholdPesewas(
    int? adjustmentApprovalThresholdPesewas,
  ) => this(
    adjustmentApprovalThresholdPesewas: adjustmentApprovalThresholdPesewas,
  );

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUser(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? staffRole = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? mfaEnrolled = const $CopyWithPlaceholder(),
    Object? lastLoginAt = const $CopyWithPlaceholder(),
    Object? lockedUntil = const $CopyWithPlaceholder(),
    Object? invitePending = const $CopyWithPlaceholder(),
    Object? adjustmentApprovalThresholdPesewas = const $CopyWithPlaceholder(),
  }) {
    return StaffUser(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      staffRole: staffRole == const $CopyWithPlaceholder()
          ? _value.staffRole
          // ignore: cast_nullable_to_non_nullable
          : staffRole as StaffRole,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
      mfaEnrolled: mfaEnrolled == const $CopyWithPlaceholder()
          ? _value.mfaEnrolled
          // ignore: cast_nullable_to_non_nullable
          : mfaEnrolled as bool,
      lastLoginAt: lastLoginAt == const $CopyWithPlaceholder()
          ? _value.lastLoginAt
          // ignore: cast_nullable_to_non_nullable
          : lastLoginAt as DateTime?,
      lockedUntil: lockedUntil == const $CopyWithPlaceholder()
          ? _value.lockedUntil
          // ignore: cast_nullable_to_non_nullable
          : lockedUntil as DateTime?,
      invitePending: invitePending == const $CopyWithPlaceholder()
          ? _value.invitePending
          // ignore: cast_nullable_to_non_nullable
          : invitePending as bool?,
      adjustmentApprovalThresholdPesewas:
          adjustmentApprovalThresholdPesewas == const $CopyWithPlaceholder()
          ? _value.adjustmentApprovalThresholdPesewas
          // ignore: cast_nullable_to_non_nullable
          : adjustmentApprovalThresholdPesewas as int?,
    );
  }
}

extension $StaffUserCopyWith on StaffUser {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUser.copyWith(...)` or like so:`instanceOfStaffUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUserCWProxy get copyWith => _$StaffUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUser _$StaffUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUser', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'email',
          'fullName',
          'staffRole',
          'isActive',
          'mfaEnrolled',
        ],
      );
      final val = StaffUser(
        id: $checkedConvert('id', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        staffRole: $checkedConvert(
          'staffRole',
          (v) => $enumDecode(_$StaffRoleEnumMap, v),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool),
        mfaEnrolled: $checkedConvert('mfaEnrolled', (v) => v as bool),
        lastLoginAt: $checkedConvert(
          'lastLoginAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        lockedUntil: $checkedConvert(
          'lockedUntil',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        invitePending: $checkedConvert('invitePending', (v) => v as bool?),
        adjustmentApprovalThresholdPesewas: $checkedConvert(
          'adjustmentApprovalThresholdPesewas',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserToJson(StaffUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'fullName': instance.fullName,
  'staffRole': _$StaffRoleEnumMap[instance.staffRole]!,
  'isActive': instance.isActive,
  'mfaEnrolled': instance.mfaEnrolled,
  'lastLoginAt': ?instance.lastLoginAt?.toIso8601String(),
  'lockedUntil': ?instance.lockedUntil?.toIso8601String(),
  'invitePending': ?instance.invitePending,
  'adjustmentApprovalThresholdPesewas':
      ?instance.adjustmentApprovalThresholdPesewas,
};

const _$StaffRoleEnumMap = {
  StaffRole.superAdmin: 'super_admin',
  StaffRole.verifier: 'verifier',
  StaffRole.dispatcher: 'dispatcher',
  StaffRole.finance: 'finance',
  StaffRole.support: 'support',
  StaffRole.hr: 'hr',
};
