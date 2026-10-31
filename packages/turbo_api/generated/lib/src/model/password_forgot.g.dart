// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_forgot.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PasswordForgotCWProxy {
  PasswordForgot email(String email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordForgot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordForgot(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordForgot call({String email});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPasswordForgot.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPasswordForgot.copyWith.fieldName(...)`
class _$PasswordForgotCWProxyImpl implements _$PasswordForgotCWProxy {
  const _$PasswordForgotCWProxyImpl(this._value);

  final PasswordForgot _value;

  @override
  PasswordForgot email(String email) => this(email: email);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PasswordForgot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PasswordForgot(...).copyWith(id: 12, name: "My name")
  /// ````
  PasswordForgot call({Object? email = const $CopyWithPlaceholder()}) {
    return PasswordForgot(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
    );
  }
}

extension $PasswordForgotCopyWith on PasswordForgot {
  /// Returns a callable class that can be used as follows: `instanceOfPasswordForgot.copyWith(...)` or like so:`instanceOfPasswordForgot.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PasswordForgotCWProxy get copyWith => _$PasswordForgotCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordForgot _$PasswordForgotFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PasswordForgot', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email']);
      final val = PasswordForgot(
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PasswordForgotToJson(PasswordForgot instance) =>
    <String, dynamic>{'email': instance.email};
