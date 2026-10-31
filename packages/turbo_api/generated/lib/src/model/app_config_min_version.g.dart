// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_min_version.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigMinVersionCWProxy {
  AppConfigMinVersion ios(String ios);

  AppConfigMinVersion android(String android);

  AppConfigMinVersion web(String web);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigMinVersion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigMinVersion(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigMinVersion call({String ios, String android, String web});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfigMinVersion.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfigMinVersion.copyWith.fieldName(...)`
class _$AppConfigMinVersionCWProxyImpl implements _$AppConfigMinVersionCWProxy {
  const _$AppConfigMinVersionCWProxyImpl(this._value);

  final AppConfigMinVersion _value;

  @override
  AppConfigMinVersion ios(String ios) => this(ios: ios);

  @override
  AppConfigMinVersion android(String android) => this(android: android);

  @override
  AppConfigMinVersion web(String web) => this(web: web);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigMinVersion(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigMinVersion(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigMinVersion call({
    Object? ios = const $CopyWithPlaceholder(),
    Object? android = const $CopyWithPlaceholder(),
    Object? web = const $CopyWithPlaceholder(),
  }) {
    return AppConfigMinVersion(
      ios: ios == const $CopyWithPlaceholder()
          ? _value.ios
          // ignore: cast_nullable_to_non_nullable
          : ios as String,
      android: android == const $CopyWithPlaceholder()
          ? _value.android
          // ignore: cast_nullable_to_non_nullable
          : android as String,
      web: web == const $CopyWithPlaceholder()
          ? _value.web
          // ignore: cast_nullable_to_non_nullable
          : web as String,
    );
  }
}

extension $AppConfigMinVersionCopyWith on AppConfigMinVersion {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfigMinVersion.copyWith(...)` or like so:`instanceOfAppConfigMinVersion.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigMinVersionCWProxy get copyWith =>
      _$AppConfigMinVersionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigMinVersion _$AppConfigMinVersionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AppConfigMinVersion', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ios', 'android', 'web']);
      final val = AppConfigMinVersion(
        ios: $checkedConvert('ios', (v) => v as String),
        android: $checkedConvert('android', (v) => v as String),
        web: $checkedConvert('web', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AppConfigMinVersionToJson(
  AppConfigMinVersion instance,
) => <String, dynamic>{
  'ios': instance.ios,
  'android': instance.android,
  'web': instance.web,
};
