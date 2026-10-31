// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_accept.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InviteAcceptCWProxy {
  InviteAccept token(String token);

  InviteAccept password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteAccept(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteAccept(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteAccept call({String token, String password});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInviteAccept.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInviteAccept.copyWith.fieldName(...)`
class _$InviteAcceptCWProxyImpl implements _$InviteAcceptCWProxy {
  const _$InviteAcceptCWProxyImpl(this._value);

  final InviteAccept _value;

  @override
  InviteAccept token(String token) => this(token: token);

  @override
  InviteAccept password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InviteAccept(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InviteAccept(...).copyWith(id: 12, name: "My name")
  /// ````
  InviteAccept call({
    Object? token = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return InviteAccept(
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

extension $InviteAcceptCopyWith on InviteAccept {
  /// Returns a callable class that can be used as follows: `instanceOfInviteAccept.copyWith(...)` or like so:`instanceOfInviteAccept.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InviteAcceptCWProxy get copyWith => _$InviteAcceptCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteAccept _$InviteAcceptFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InviteAccept', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token', 'password']);
      final val = InviteAccept(
        token: $checkedConvert('token', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$InviteAcceptToJson(InviteAccept instance) =>
    <String, dynamic>{'token': instance.token, 'password': instance.password};
