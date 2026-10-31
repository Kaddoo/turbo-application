// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpRequestCWProxy {
  OtpRequest phone(String phone);

  OtpRequest role(OtpRequestRoleEnum role);

  OtpRequest deviceId(String? deviceId);

  OtpRequest captchaToken(String? captchaToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpRequest call({
    String phone,
    OtpRequestRoleEnum role,
    String? deviceId,
    String? captchaToken,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpRequest.copyWith.fieldName(...)`
class _$OtpRequestCWProxyImpl implements _$OtpRequestCWProxy {
  const _$OtpRequestCWProxyImpl(this._value);

  final OtpRequest _value;

  @override
  OtpRequest phone(String phone) => this(phone: phone);

  @override
  OtpRequest role(OtpRequestRoleEnum role) => this(role: role);

  @override
  OtpRequest deviceId(String? deviceId) => this(deviceId: deviceId);

  @override
  OtpRequest captchaToken(String? captchaToken) =>
      this(captchaToken: captchaToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpRequest call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? captchaToken = const $CopyWithPlaceholder(),
  }) {
    return OtpRequest(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as OtpRequestRoleEnum,
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String?,
      captchaToken: captchaToken == const $CopyWithPlaceholder()
          ? _value.captchaToken
          // ignore: cast_nullable_to_non_nullable
          : captchaToken as String?,
    );
  }
}

extension $OtpRequestCopyWith on OtpRequest {
  /// Returns a callable class that can be used as follows: `instanceOfOtpRequest.copyWith(...)` or like so:`instanceOfOtpRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpRequestCWProxy get copyWith => _$OtpRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequest _$OtpRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'role']);
      final val = OtpRequest(
        phone: $checkedConvert('phone', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$OtpRequestRoleEnumEnumMap, v),
        ),
        deviceId: $checkedConvert('deviceId', (v) => v as String?),
        captchaToken: $checkedConvert('captchaToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$OtpRequestToJson(OtpRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'role': _$OtpRequestRoleEnumEnumMap[instance.role]!,
      'deviceId': ?instance.deviceId,
      'captchaToken': ?instance.captchaToken,
    };

const _$OtpRequestRoleEnumEnumMap = {
  OtpRequestRoleEnum.student: 'student',
  OtpRequestRoleEnum.driver: 'driver',
};
