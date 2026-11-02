// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationSettingsCWProxy {
  NotificationSettings newsAndOffers(bool newsAndOffers);

  NotificationSettings tips(bool tips);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationSettings call({bool newsAndOffers, bool tips});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationSettings.copyWith.fieldName(...)`
class _$NotificationSettingsCWProxyImpl
    implements _$NotificationSettingsCWProxy {
  const _$NotificationSettingsCWProxyImpl(this._value);

  final NotificationSettings _value;

  @override
  NotificationSettings newsAndOffers(bool newsAndOffers) =>
      this(newsAndOffers: newsAndOffers);

  @override
  NotificationSettings tips(bool tips) => this(tips: tips);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationSettings call({
    Object? newsAndOffers = const $CopyWithPlaceholder(),
    Object? tips = const $CopyWithPlaceholder(),
  }) {
    return NotificationSettings(
      newsAndOffers: newsAndOffers == const $CopyWithPlaceholder()
          ? _value.newsAndOffers
          // ignore: cast_nullable_to_non_nullable
          : newsAndOffers as bool,
      tips: tips == const $CopyWithPlaceholder()
          ? _value.tips
          // ignore: cast_nullable_to_non_nullable
          : tips as bool,
    );
  }
}

extension $NotificationSettingsCopyWith on NotificationSettings {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationSettings.copyWith(...)` or like so:`instanceOfNotificationSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationSettingsCWProxy get copyWith =>
      _$NotificationSettingsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NotificationSettings', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['newsAndOffers', 'tips']);
  final val = NotificationSettings(
    newsAndOffers: $checkedConvert('newsAndOffers', (v) => v as bool),
    tips: $checkedConvert('tips', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'newsAndOffers': instance.newsAndOffers,
  'tips': instance.tips,
};
