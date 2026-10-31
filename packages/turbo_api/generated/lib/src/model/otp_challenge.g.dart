// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_challenge.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpChallengeCWProxy {
  OtpChallenge expiresInSeconds(int expiresInSeconds);

  OtpChallenge resendInSeconds(int resendInSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpChallenge(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpChallenge(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpChallenge call({int expiresInSeconds, int resendInSeconds});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpChallenge.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpChallenge.copyWith.fieldName(...)`
class _$OtpChallengeCWProxyImpl implements _$OtpChallengeCWProxy {
  const _$OtpChallengeCWProxyImpl(this._value);

  final OtpChallenge _value;

  @override
  OtpChallenge expiresInSeconds(int expiresInSeconds) =>
      this(expiresInSeconds: expiresInSeconds);

  @override
  OtpChallenge resendInSeconds(int resendInSeconds) =>
      this(resendInSeconds: resendInSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpChallenge(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpChallenge(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpChallenge call({
    Object? expiresInSeconds = const $CopyWithPlaceholder(),
    Object? resendInSeconds = const $CopyWithPlaceholder(),
  }) {
    return OtpChallenge(
      expiresInSeconds: expiresInSeconds == const $CopyWithPlaceholder()
          ? _value.expiresInSeconds
          // ignore: cast_nullable_to_non_nullable
          : expiresInSeconds as int,
      resendInSeconds: resendInSeconds == const $CopyWithPlaceholder()
          ? _value.resendInSeconds
          // ignore: cast_nullable_to_non_nullable
          : resendInSeconds as int,
    );
  }
}

extension $OtpChallengeCopyWith on OtpChallenge {
  /// Returns a callable class that can be used as follows: `instanceOfOtpChallenge.copyWith(...)` or like so:`instanceOfOtpChallenge.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpChallengeCWProxy get copyWith => _$OtpChallengeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpChallenge _$OtpChallengeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpChallenge', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['expiresInSeconds', 'resendInSeconds'],
      );
      final val = OtpChallenge(
        expiresInSeconds: $checkedConvert(
          'expiresInSeconds',
          (v) => (v as num).toInt(),
        ),
        resendInSeconds: $checkedConvert(
          'resendInSeconds',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OtpChallengeToJson(OtpChallenge instance) =>
    <String, dynamic>{
      'expiresInSeconds': instance.expiresInSeconds,
      'resendInSeconds': instance.resendInSeconds,
    };
