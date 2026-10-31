// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffCreateCWProxy {
  StaffCreate email(String email);

  StaffCreate fullName(String fullName);

  StaffCreate staffRole(StaffRole staffRole);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffCreate call({String email, String fullName, StaffRole staffRole});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffCreate.copyWith.fieldName(...)`
class _$StaffCreateCWProxyImpl implements _$StaffCreateCWProxy {
  const _$StaffCreateCWProxyImpl(this._value);

  final StaffCreate _value;

  @override
  StaffCreate email(String email) => this(email: email);

  @override
  StaffCreate fullName(String fullName) => this(fullName: fullName);

  @override
  StaffCreate staffRole(StaffRole staffRole) => this(staffRole: staffRole);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffCreate call({
    Object? email = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? staffRole = const $CopyWithPlaceholder(),
  }) {
    return StaffCreate(
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
    );
  }
}

extension $StaffCreateCopyWith on StaffCreate {
  /// Returns a callable class that can be used as follows: `instanceOfStaffCreate.copyWith(...)` or like so:`instanceOfStaffCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffCreateCWProxy get copyWith => _$StaffCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffCreate _$StaffCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email', 'fullName', 'staffRole']);
      final val = StaffCreate(
        email: $checkedConvert('email', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        staffRole: $checkedConvert(
          'staffRole',
          (v) => $enumDecode(_$StaffRoleEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffCreateToJson(StaffCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'staffRole': _$StaffRoleEnumMap[instance.staffRole]!,
    };

const _$StaffRoleEnumMap = {
  StaffRole.superAdmin: 'super_admin',
  StaffRole.verifier: 'verifier',
  StaffRole.dispatcher: 'dispatcher',
  StaffRole.finance: 'finance',
  StaffRole.support: 'support',
  StaffRole.hr: 'hr',
};
