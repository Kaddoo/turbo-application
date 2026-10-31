// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthTokensCWProxy {
  AuthTokens accessToken(String accessToken);

  AuthTokens expiresInSeconds(int expiresInSeconds);

  AuthTokens refreshToken(String? refreshToken);

  AuthTokens user(SessionUser user);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthTokens(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthTokens(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthTokens call({
    String accessToken,
    int expiresInSeconds,
    String? refreshToken,
    SessionUser user,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthTokens.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthTokens.copyWith.fieldName(...)`
class _$AuthTokensCWProxyImpl implements _$AuthTokensCWProxy {
  const _$AuthTokensCWProxyImpl(this._value);

  final AuthTokens _value;

  @override
  AuthTokens accessToken(String accessToken) => this(accessToken: accessToken);

  @override
  AuthTokens expiresInSeconds(int expiresInSeconds) =>
      this(expiresInSeconds: expiresInSeconds);

  @override
  AuthTokens refreshToken(String? refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  AuthTokens user(SessionUser user) => this(user: user);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthTokens(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthTokens(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthTokens call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? expiresInSeconds = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return AuthTokens(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      expiresInSeconds: expiresInSeconds == const $CopyWithPlaceholder()
          ? _value.expiresInSeconds
          // ignore: cast_nullable_to_non_nullable
          : expiresInSeconds as int,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as SessionUser,
    );
  }
}

extension $AuthTokensCopyWith on AuthTokens {
  /// Returns a callable class that can be used as follows: `instanceOfAuthTokens.copyWith(...)` or like so:`instanceOfAuthTokens.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthTokensCWProxy get copyWith => _$AuthTokensCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuthTokens', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['accessToken', 'expiresInSeconds', 'user'],
      );
      final val = AuthTokens(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        expiresInSeconds: $checkedConvert(
          'expiresInSeconds',
          (v) => (v as num).toInt(),
        ),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
        user: $checkedConvert(
          'user',
          (v) => SessionUser.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuthTokensToJson(AuthTokens instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresInSeconds': instance.expiresInSeconds,
      'refreshToken': ?instance.refreshToken,
      'user': instance.user.toJson(),
    };
