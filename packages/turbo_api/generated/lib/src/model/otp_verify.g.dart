// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpVerifyCWProxy {
  OtpVerify phone(String phone);

  OtpVerify code(String code);

  OtpVerify role(OtpVerifyRoleEnum role);

  OtpVerify clientType(OtpVerifyClientTypeEnum clientType);

  OtpVerify acceptedTermsVersion(String? acceptedTermsVersion);

  OtpVerify acceptedPrivacyVersion(String? acceptedPrivacyVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpVerify(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpVerify(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpVerify call({
    String phone,
    String code,
    OtpVerifyRoleEnum role,
    OtpVerifyClientTypeEnum clientType,
    String? acceptedTermsVersion,
    String? acceptedPrivacyVersion,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpVerify.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpVerify.copyWith.fieldName(...)`
class _$OtpVerifyCWProxyImpl implements _$OtpVerifyCWProxy {
  const _$OtpVerifyCWProxyImpl(this._value);

  final OtpVerify _value;

  @override
  OtpVerify phone(String phone) => this(phone: phone);

  @override
  OtpVerify code(String code) => this(code: code);

  @override
  OtpVerify role(OtpVerifyRoleEnum role) => this(role: role);

  @override
  OtpVerify clientType(OtpVerifyClientTypeEnum clientType) =>
      this(clientType: clientType);

  @override
  OtpVerify acceptedTermsVersion(String? acceptedTermsVersion) =>
      this(acceptedTermsVersion: acceptedTermsVersion);

  @override
  OtpVerify acceptedPrivacyVersion(String? acceptedPrivacyVersion) =>
      this(acceptedPrivacyVersion: acceptedPrivacyVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpVerify(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpVerify(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpVerify call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? clientType = const $CopyWithPlaceholder(),
    Object? acceptedTermsVersion = const $CopyWithPlaceholder(),
    Object? acceptedPrivacyVersion = const $CopyWithPlaceholder(),
  }) {
    return OtpVerify(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as OtpVerifyRoleEnum,
      clientType: clientType == const $CopyWithPlaceholder()
          ? _value.clientType
          // ignore: cast_nullable_to_non_nullable
          : clientType as OtpVerifyClientTypeEnum,
      acceptedTermsVersion: acceptedTermsVersion == const $CopyWithPlaceholder()
          ? _value.acceptedTermsVersion
          // ignore: cast_nullable_to_non_nullable
          : acceptedTermsVersion as String?,
      acceptedPrivacyVersion:
          acceptedPrivacyVersion == const $CopyWithPlaceholder()
          ? _value.acceptedPrivacyVersion
          // ignore: cast_nullable_to_non_nullable
          : acceptedPrivacyVersion as String?,
    );
  }
}

extension $OtpVerifyCopyWith on OtpVerify {
  /// Returns a callable class that can be used as follows: `instanceOfOtpVerify.copyWith(...)` or like so:`instanceOfOtpVerify.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpVerifyCWProxy get copyWith => _$OtpVerifyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerify _$OtpVerifyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpVerify', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['phone', 'code', 'role', 'clientType'],
      );
      final val = OtpVerify(
        phone: $checkedConvert('phone', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$OtpVerifyRoleEnumEnumMap, v),
        ),
        clientType: $checkedConvert(
          'clientType',
          (v) => $enumDecode(_$OtpVerifyClientTypeEnumEnumMap, v),
        ),
        acceptedTermsVersion: $checkedConvert(
          'acceptedTermsVersion',
          (v) => v as String?,
        ),
        acceptedPrivacyVersion: $checkedConvert(
          'acceptedPrivacyVersion',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$OtpVerifyToJson(OtpVerify instance) => <String, dynamic>{
  'phone': instance.phone,
  'code': instance.code,
  'role': _$OtpVerifyRoleEnumEnumMap[instance.role]!,
  'clientType': _$OtpVerifyClientTypeEnumEnumMap[instance.clientType]!,
  'acceptedTermsVersion': ?instance.acceptedTermsVersion,
  'acceptedPrivacyVersion': ?instance.acceptedPrivacyVersion,
};

const _$OtpVerifyRoleEnumEnumMap = {
  OtpVerifyRoleEnum.student: 'student',
  OtpVerifyRoleEnum.driver: 'driver',
};

const _$OtpVerifyClientTypeEnumEnumMap = {
  OtpVerifyClientTypeEnum.mobile: 'mobile',
  OtpVerifyClientTypeEnum.web: 'web',
};
