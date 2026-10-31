// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_maintenance.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigMaintenanceCWProxy {
  AppConfigMaintenance active(bool active);

  AppConfigMaintenance message(String? message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigMaintenance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigMaintenance(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigMaintenance call({bool active, String? message});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfigMaintenance.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfigMaintenance.copyWith.fieldName(...)`
class _$AppConfigMaintenanceCWProxyImpl
    implements _$AppConfigMaintenanceCWProxy {
  const _$AppConfigMaintenanceCWProxyImpl(this._value);

  final AppConfigMaintenance _value;

  @override
  AppConfigMaintenance active(bool active) => this(active: active);

  @override
  AppConfigMaintenance message(String? message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigMaintenance(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigMaintenance(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigMaintenance call({
    Object? active = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return AppConfigMaintenance(
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
    );
  }
}

extension $AppConfigMaintenanceCopyWith on AppConfigMaintenance {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfigMaintenance.copyWith(...)` or like so:`instanceOfAppConfigMaintenance.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigMaintenanceCWProxy get copyWith =>
      _$AppConfigMaintenanceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigMaintenance _$AppConfigMaintenanceFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AppConfigMaintenance', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['active']);
  final val = AppConfigMaintenance(
    active: $checkedConvert('active', (v) => v as bool),
    message: $checkedConvert('message', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AppConfigMaintenanceToJson(
  AppConfigMaintenance instance,
) => <String, dynamic>{'active': instance.active, 'message': ?instance.message};
