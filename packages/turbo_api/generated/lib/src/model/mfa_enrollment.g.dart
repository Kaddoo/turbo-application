// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MfaEnrollmentCWProxy {
  MfaEnrollment enrollmentToken(String enrollmentToken);

  MfaEnrollment secret(String secret);

  MfaEnrollment otpauthUri(String otpauthUri);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MfaEnrollment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MfaEnrollment(...).copyWith(id: 12, name: "My name")
  /// ````
  MfaEnrollment call({
    String enrollmentToken,
    String secret,
    String otpauthUri,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMfaEnrollment.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMfaEnrollment.copyWith.fieldName(...)`
class _$MfaEnrollmentCWProxyImpl implements _$MfaEnrollmentCWProxy {
  const _$MfaEnrollmentCWProxyImpl(this._value);

  final MfaEnrollment _value;

  @override
  MfaEnrollment enrollmentToken(String enrollmentToken) =>
      this(enrollmentToken: enrollmentToken);

  @override
  MfaEnrollment secret(String secret) => this(secret: secret);

  @override
  MfaEnrollment otpauthUri(String otpauthUri) => this(otpauthUri: otpauthUri);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MfaEnrollment(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MfaEnrollment(...).copyWith(id: 12, name: "My name")
  /// ````
  MfaEnrollment call({
    Object? enrollmentToken = const $CopyWithPlaceholder(),
    Object? secret = const $CopyWithPlaceholder(),
    Object? otpauthUri = const $CopyWithPlaceholder(),
  }) {
    return MfaEnrollment(
      enrollmentToken: enrollmentToken == const $CopyWithPlaceholder()
          ? _value.enrollmentToken
          // ignore: cast_nullable_to_non_nullable
          : enrollmentToken as String,
      secret: secret == const $CopyWithPlaceholder()
          ? _value.secret
          // ignore: cast_nullable_to_non_nullable
          : secret as String,
      otpauthUri: otpauthUri == const $CopyWithPlaceholder()
          ? _value.otpauthUri
          // ignore: cast_nullable_to_non_nullable
          : otpauthUri as String,
    );
  }
}

extension $MfaEnrollmentCopyWith on MfaEnrollment {
  /// Returns a callable class that can be used as follows: `instanceOfMfaEnrollment.copyWith(...)` or like so:`instanceOfMfaEnrollment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MfaEnrollmentCWProxy get copyWith => _$MfaEnrollmentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MfaEnrollment _$MfaEnrollmentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MfaEnrollment', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['enrollmentToken', 'secret', 'otpauthUri'],
      );
      final val = MfaEnrollment(
        enrollmentToken: $checkedConvert('enrollmentToken', (v) => v as String),
        secret: $checkedConvert('secret', (v) => v as String),
        otpauthUri: $checkedConvert('otpauthUri', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MfaEnrollmentToJson(MfaEnrollment instance) =>
    <String, dynamic>{
      'enrollmentToken': instance.enrollmentToken,
      'secret': instance.secret,
      'otpauthUri': instance.otpauthUri,
    };
