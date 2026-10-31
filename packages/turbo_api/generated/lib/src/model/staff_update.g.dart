// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUpdateCWProxy {
  StaffUpdate staffRole(StaffRole? staffRole);

  StaffUpdate isActive(bool? isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUpdate call({StaffRole? staffRole, bool? isActive});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUpdate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUpdate.copyWith.fieldName(...)`
class _$StaffUpdateCWProxyImpl implements _$StaffUpdateCWProxy {
  const _$StaffUpdateCWProxyImpl(this._value);

  final StaffUpdate _value;

  @override
  StaffUpdate staffRole(StaffRole? staffRole) => this(staffRole: staffRole);

  @override
  StaffUpdate isActive(bool? isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUpdate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUpdate(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUpdate call({
    Object? staffRole = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return StaffUpdate(
      staffRole: staffRole == const $CopyWithPlaceholder()
          ? _value.staffRole
          // ignore: cast_nullable_to_non_nullable
          : staffRole as StaffRole?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
    );
  }
}

extension $StaffUpdateCopyWith on StaffUpdate {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUpdate.copyWith(...)` or like so:`instanceOfStaffUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUpdateCWProxy get copyWith => _$StaffUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUpdate _$StaffUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUpdate', json, ($checkedConvert) {
      final val = StaffUpdate(
        staffRole: $checkedConvert(
          'staffRole',
          (v) => $enumDecodeNullable(_$StaffRoleEnumMap, v),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$StaffUpdateToJson(StaffUpdate instance) =>
    <String, dynamic>{
      'staffRole': ?_$StaffRoleEnumMap[instance.staffRole],
      'isActive': ?instance.isActive,
    };

const _$StaffRoleEnumMap = {
  StaffRole.superAdmin: 'super_admin',
  StaffRole.verifier: 'verifier',
  StaffRole.dispatcher: 'dispatcher',
  StaffRole.finance: 'finance',
  StaffRole.support: 'support',
  StaffRole.hr: 'hr',
};
