// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_registration.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeviceRegistrationCWProxy {
  DeviceRegistration deviceId(String deviceId);

  DeviceRegistration fcmToken(String fcmToken);

  DeviceRegistration platform(DeviceRegistrationPlatformEnum platform);

  DeviceRegistration appVersion(String? appVersion);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeviceRegistration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeviceRegistration(...).copyWith(id: 12, name: "My name")
  /// ````
  DeviceRegistration call({
    String deviceId,
    String fcmToken,
    DeviceRegistrationPlatformEnum platform,
    String? appVersion,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeviceRegistration.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeviceRegistration.copyWith.fieldName(...)`
class _$DeviceRegistrationCWProxyImpl implements _$DeviceRegistrationCWProxy {
  const _$DeviceRegistrationCWProxyImpl(this._value);

  final DeviceRegistration _value;

  @override
  DeviceRegistration deviceId(String deviceId) => this(deviceId: deviceId);

  @override
  DeviceRegistration fcmToken(String fcmToken) => this(fcmToken: fcmToken);

  @override
  DeviceRegistration platform(DeviceRegistrationPlatformEnum platform) =>
      this(platform: platform);

  @override
  DeviceRegistration appVersion(String? appVersion) =>
      this(appVersion: appVersion);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeviceRegistration(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeviceRegistration(...).copyWith(id: 12, name: "My name")
  /// ````
  DeviceRegistration call({
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? fcmToken = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? appVersion = const $CopyWithPlaceholder(),
  }) {
    return DeviceRegistration(
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
      fcmToken: fcmToken == const $CopyWithPlaceholder()
          ? _value.fcmToken
          // ignore: cast_nullable_to_non_nullable
          : fcmToken as String,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as DeviceRegistrationPlatformEnum,
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String?,
    );
  }
}

extension $DeviceRegistrationCopyWith on DeviceRegistration {
  /// Returns a callable class that can be used as follows: `instanceOfDeviceRegistration.copyWith(...)` or like so:`instanceOfDeviceRegistration.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeviceRegistrationCWProxy get copyWith =>
      _$DeviceRegistrationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRegistration _$DeviceRegistrationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceRegistration', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['deviceId', 'fcmToken', 'platform'],
      );
      final val = DeviceRegistration(
        deviceId: $checkedConvert('deviceId', (v) => v as String),
        fcmToken: $checkedConvert('fcmToken', (v) => v as String),
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecode(_$DeviceRegistrationPlatformEnumEnumMap, v),
        ),
        appVersion: $checkedConvert('appVersion', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceRegistrationToJson(DeviceRegistration instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
      'platform': _$DeviceRegistrationPlatformEnumEnumMap[instance.platform]!,
      'appVersion': ?instance.appVersion,
    };

const _$DeviceRegistrationPlatformEnumEnumMap = {
  DeviceRegistrationPlatformEnum.ios: 'ios',
  DeviceRegistrationPlatformEnum.android: 'android',
  DeviceRegistrationPlatformEnum.web: 'web',
};
