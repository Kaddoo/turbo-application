// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PasswordResetCWProxy {
  PasswordReset token(String token);

  PasswordReset password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordReset(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordReset(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordReset call({String token, String password});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPasswordReset.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPasswordReset.copyWith.fieldName(...)`
class _$PasswordResetCWProxyImpl implements _$PasswordResetCWProxy {
  const _$PasswordResetCWProxyImpl(this._value);

  final PasswordReset _value;

  @override
  PasswordReset token(String token) => this(token: token);

  @override
  PasswordReset password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordReset(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordReset(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordReset call({
    Object? token = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return PasswordReset(
      token: token == const $CopyWithPlaceholder()
          ? _value.token
          // ignore: cast_nullable_to_non_nullable
          : token as String,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $PasswordResetCopyWith on PasswordReset {
  /// Returns a callable class that can be used as follows: `instanceOfPasswordReset.copyWith(...)` or like so:`instanceOfPasswordReset.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PasswordResetCWProxy get copyWith => _$PasswordResetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordReset _$PasswordResetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PasswordReset', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token', 'password']);
      final val = PasswordReset(
        token: $checkedConvert('token', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PasswordResetToJson(PasswordReset instance) =>
    <String, dynamic>{'token': instance.token, 'password': instance.password};
