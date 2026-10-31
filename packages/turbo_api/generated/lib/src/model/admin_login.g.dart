// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_login.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminLoginCWProxy {
  AdminLogin email(String email);

  AdminLogin password(String password);

  AdminLogin totpCode(String? totpCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLogin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLogin(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLogin call({String email, String password, String? totpCode});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminLogin.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminLogin.copyWith.fieldName(...)`
class _$AdminLoginCWProxyImpl implements _$AdminLoginCWProxy {
  const _$AdminLoginCWProxyImpl(this._value);

  final AdminLogin _value;

  @override
  AdminLogin email(String email) => this(email: email);

  @override
  AdminLogin password(String password) => this(password: password);

  @override
  AdminLogin totpCode(String? totpCode) => this(totpCode: totpCode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLogin(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLogin(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLogin call({
    Object? email = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? totpCode = const $CopyWithPlaceholder(),
  }) {
    return AdminLogin(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
      totpCode: totpCode == const $CopyWithPlaceholder()
          ? _value.totpCode
          // ignore: cast_nullable_to_non_nullable
          : totpCode as String?,
    );
  }
}

extension $AdminLoginCopyWith on AdminLogin {
  /// Returns a callable class that can be used as follows: `instanceOfAdminLogin.copyWith(...)` or like so:`instanceOfAdminLogin.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminLoginCWProxy get copyWith => _$AdminLoginCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminLogin _$AdminLoginFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminLogin', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email', 'password']);
      final val = AdminLogin(
        email: $checkedConvert('email', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
        totpCode: $checkedConvert('totpCode', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminLoginToJson(AdminLogin instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'totpCode': ?instance.totpCode,
    };
