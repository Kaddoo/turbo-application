// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SessionUserCWProxy {
  SessionUser id(String id);

  SessionUser role(UserRole role);

  SessionUser staffRole(StaffRole? staffRole);

  SessionUser displayName(String? displayName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionUser(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionUser call({
    String id,
    UserRole role,
    StaffRole? staffRole,
    String? displayName,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSessionUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSessionUser.copyWith.fieldName(...)`
class _$SessionUserCWProxyImpl implements _$SessionUserCWProxy {
  const _$SessionUserCWProxyImpl(this._value);

  final SessionUser _value;

  @override
  SessionUser id(String id) => this(id: id);

  @override
  SessionUser role(UserRole role) => this(role: role);

  @override
  SessionUser staffRole(StaffRole? staffRole) => this(staffRole: staffRole);

  @override
  SessionUser displayName(String? displayName) =>
      this(displayName: displayName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionUser(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionUser(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionUser call({
    Object? id = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? staffRole = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
  }) {
    return SessionUser(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserRole,
      staffRole: staffRole == const $CopyWithPlaceholder()
          ? _value.staffRole
          // ignore: cast_nullable_to_non_nullable
          : staffRole as StaffRole?,
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String?,
    );
  }
}

extension $SessionUserCopyWith on SessionUser {
  /// Returns a callable class that can be used as follows: `instanceOfSessionUser.copyWith(...)` or like so:`instanceOfSessionUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SessionUserCWProxy get copyWith => _$SessionUserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionUser _$SessionUserFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SessionUser', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'role']);
      final val = SessionUser(
        id: $checkedConvert('id', (v) => v as String),
        role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
        staffRole: $checkedConvert(
          'staffRole',
          (v) => $enumDecodeNullable(_$StaffRoleEnumMap, v),
        ),
        displayName: $checkedConvert('displayName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SessionUserToJson(SessionUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$UserRoleEnumMap[instance.role]!,
      'staffRole': ?_$StaffRoleEnumMap[instance.staffRole],
      'displayName': ?instance.displayName,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.driver: 'driver',
  UserRole.admin: 'admin',
};

const _$StaffRoleEnumMap = {
  StaffRole.superAdmin: 'super_admin',
  StaffRole.verifier: 'verifier',
  StaffRole.dispatcher: 'dispatcher',
  StaffRole.finance: 'finance',
  StaffRole.support: 'support',
  StaffRole.hr: 'hr',
};
