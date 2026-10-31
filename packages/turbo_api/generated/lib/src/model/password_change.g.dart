// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_change.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PasswordChangeCWProxy {
  PasswordChange currentPassword(String currentPassword);

  PasswordChange newPassword(String newPassword);

  PasswordChange totpCode(String totpCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordChange(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordChange call({
    String currentPassword,
    String newPassword,
    String totpCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPasswordChange.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPasswordChange.copyWith.fieldName(...)`
class _$PasswordChangeCWProxyImpl implements _$PasswordChangeCWProxy {
  const _$PasswordChangeCWProxyImpl(this._value);

  final PasswordChange _value;

  @override
  PasswordChange currentPassword(String currentPassword) =>
      this(currentPassword: currentPassword);

  @override
  PasswordChange newPassword(String newPassword) =>
      this(newPassword: newPassword);

  @override
  PasswordChange totpCode(String totpCode) => this(totpCode: totpCode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordChange(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordChange call({
    Object? currentPassword = const $CopyWithPlaceholder(),
    Object? newPassword = const $CopyWithPlaceholder(),
    Object? totpCode = const $CopyWithPlaceholder(),
  }) {
    return PasswordChange(
      currentPassword: currentPassword == const $CopyWithPlaceholder()
          ? _value.currentPassword
          // ignore: cast_nullable_to_non_nullable
          : currentPassword as String,
      newPassword: newPassword == const $CopyWithPlaceholder()
          ? _value.newPassword
          // ignore: cast_nullable_to_non_nullable
          : newPassword as String,
      totpCode: totpCode == const $CopyWithPlaceholder()
          ? _value.totpCode
          // ignore: cast_nullable_to_non_nullable
          : totpCode as String,
    );
  }
}

extension $PasswordChangeCopyWith on PasswordChange {
  /// Returns a callable class that can be used as follows: `instanceOfPasswordChange.copyWith(...)` or like so:`instanceOfPasswordChange.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PasswordChangeCWProxy get copyWith => _$PasswordChangeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordChange _$PasswordChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PasswordChange', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['currentPassword', 'newPassword', 'totpCode'],
      );
      final val = PasswordChange(
        currentPassword: $checkedConvert('currentPassword', (v) => v as String),
        newPassword: $checkedConvert('newPassword', (v) => v as String),
        totpCode: $checkedConvert('totpCode', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PasswordChangeToJson(PasswordChange instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
      'totpCode': instance.totpCode,
    };
