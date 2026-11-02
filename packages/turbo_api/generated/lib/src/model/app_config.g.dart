// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigCWProxy {
  AppConfig minVersion(AppConfigMinVersion minVersion);

  AppConfig maintenance(AppConfigMaintenance maintenance);

  AppConfig bookingsPaused(bool bookingsPaused);

  AppConfig pauseMessage(String? pauseMessage);

  AppConfig supervisorPhone(String? supervisorPhone);

  AppConfig campusSecurityPhone(String? campusSecurityPhone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfig call({
    AppConfigMinVersion minVersion,
    AppConfigMaintenance maintenance,
    bool bookingsPaused,
    String? pauseMessage,
    String? supervisorPhone,
    String? campusSecurityPhone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfig.copyWith.fieldName(...)`
class _$AppConfigCWProxyImpl implements _$AppConfigCWProxy {
  const _$AppConfigCWProxyImpl(this._value);

  final AppConfig _value;

  @override
  AppConfig minVersion(AppConfigMinVersion minVersion) =>
      this(minVersion: minVersion);

  @override
  AppConfig maintenance(AppConfigMaintenance maintenance) =>
      this(maintenance: maintenance);

  @override
  AppConfig bookingsPaused(bool bookingsPaused) =>
      this(bookingsPaused: bookingsPaused);

  @override
  AppConfig pauseMessage(String? pauseMessage) =>
      this(pauseMessage: pauseMessage);

  @override
  AppConfig supervisorPhone(String? supervisorPhone) =>
      this(supervisorPhone: supervisorPhone);

  @override
  AppConfig campusSecurityPhone(String? campusSecurityPhone) =>
      this(campusSecurityPhone: campusSecurityPhone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfig(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfig(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfig call({
    Object? minVersion = const $CopyWithPlaceholder(),
    Object? maintenance = const $CopyWithPlaceholder(),
    Object? bookingsPaused = const $CopyWithPlaceholder(),
    Object? pauseMessage = const $CopyWithPlaceholder(),
    Object? supervisorPhone = const $CopyWithPlaceholder(),
    Object? campusSecurityPhone = const $CopyWithPlaceholder(),
  }) {
    return AppConfig(
      minVersion: minVersion == const $CopyWithPlaceholder()
          ? _value.minVersion
          // ignore: cast_nullable_to_non_nullable
          : minVersion as AppConfigMinVersion,
      maintenance: maintenance == const $CopyWithPlaceholder()
          ? _value.maintenance
          // ignore: cast_nullable_to_non_nullable
          : maintenance as AppConfigMaintenance,
      bookingsPaused: bookingsPaused == const $CopyWithPlaceholder()
          ? _value.bookingsPaused
          // ignore: cast_nullable_to_non_nullable
          : bookingsPaused as bool,
      pauseMessage: pauseMessage == const $CopyWithPlaceholder()
          ? _value.pauseMessage
          // ignore: cast_nullable_to_non_nullable
          : pauseMessage as String?,
      supervisorPhone: supervisorPhone == const $CopyWithPlaceholder()
          ? _value.supervisorPhone
          // ignore: cast_nullable_to_non_nullable
          : supervisorPhone as String?,
      campusSecurityPhone: campusSecurityPhone == const $CopyWithPlaceholder()
          ? _value.campusSecurityPhone
          // ignore: cast_nullable_to_non_nullable
          : campusSecurityPhone as String?,
    );
  }
}

extension $AppConfigCopyWith on AppConfig {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfig.copyWith(...)` or like so:`instanceOfAppConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigCWProxy get copyWith => _$AppConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AppConfig',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['minVersion', 'maintenance', 'bookingsPaused'],
    );
    final val = AppConfig(
      minVersion: $checkedConvert(
        'minVersion',
        (v) => AppConfigMinVersion.fromJson(v as Map<String, dynamic>),
      ),
      maintenance: $checkedConvert(
        'maintenance',
        (v) => AppConfigMaintenance.fromJson(v as Map<String, dynamic>),
      ),
      bookingsPaused: $checkedConvert('bookingsPaused', (v) => v as bool),
      pauseMessage: $checkedConvert('pauseMessage', (v) => v as String?),
      supervisorPhone: $checkedConvert('supervisorPhone', (v) => v as String?),
      campusSecurityPhone: $checkedConvert(
        'campusSecurityPhone',
        (v) => v as String?,
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'minVersion': instance.minVersion.toJson(),
  'maintenance': instance.maintenance.toJson(),
  'bookingsPaused': instance.bookingsPaused,
  'pauseMessage': ?instance.pauseMessage,
  'supervisorPhone': ?instance.supervisorPhone,
  'campusSecurityPhone': ?instance.campusSecurityPhone,
};
