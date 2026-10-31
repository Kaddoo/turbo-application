// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SessionCWProxy {
  Session id(String id);

  Session platform(SessionPlatformEnum platform);

  Session deviceName(String? deviceName);

  Session lastUsedAt(DateTime lastUsedAt);

  Session current(bool current);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Session(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Session(...).copyWith(id: 12, name: "My name")
  /// ````
  Session call({
    String id,
    SessionPlatformEnum platform,
    String? deviceName,
    DateTime lastUsedAt,
    bool current,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSession.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSession.copyWith.fieldName(...)`
class _$SessionCWProxyImpl implements _$SessionCWProxy {
  const _$SessionCWProxyImpl(this._value);

  final Session _value;

  @override
  Session id(String id) => this(id: id);

  @override
  Session platform(SessionPlatformEnum platform) => this(platform: platform);

  @override
  Session deviceName(String? deviceName) => this(deviceName: deviceName);

  @override
  Session lastUsedAt(DateTime lastUsedAt) => this(lastUsedAt: lastUsedAt);

  @override
  Session current(bool current) => this(current: current);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Session(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Session(...).copyWith(id: 12, name: "My name")
  /// ````
  Session call({
    Object? id = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? deviceName = const $CopyWithPlaceholder(),
    Object? lastUsedAt = const $CopyWithPlaceholder(),
    Object? current = const $CopyWithPlaceholder(),
  }) {
    return Session(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as SessionPlatformEnum,
      deviceName: deviceName == const $CopyWithPlaceholder()
          ? _value.deviceName
          // ignore: cast_nullable_to_non_nullable
          : deviceName as String?,
      lastUsedAt: lastUsedAt == const $CopyWithPlaceholder()
          ? _value.lastUsedAt
          // ignore: cast_nullable_to_non_nullable
          : lastUsedAt as DateTime,
      current: current == const $CopyWithPlaceholder()
          ? _value.current
          // ignore: cast_nullable_to_non_nullable
          : current as bool,
    );
  }
}

extension $SessionCopyWith on Session {
  /// Returns a callable class that can be used as follows: `instanceOfSession.copyWith(...)` or like so:`instanceOfSession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SessionCWProxy get copyWith => _$SessionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Session', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'platform', 'lastUsedAt', 'current'],
      );
      final val = Session(
        id: $checkedConvert('id', (v) => v as String),
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecode(_$SessionPlatformEnumEnumMap, v),
        ),
        deviceName: $checkedConvert('deviceName', (v) => v as String?),
        lastUsedAt: $checkedConvert(
          'lastUsedAt',
          (v) => DateTime.parse(v as String),
        ),
        current: $checkedConvert('current', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'platform': _$SessionPlatformEnumEnumMap[instance.platform]!,
  'deviceName': ?instance.deviceName,
  'lastUsedAt': instance.lastUsedAt.toIso8601String(),
  'current': instance.current,
};

const _$SessionPlatformEnumEnumMap = {
  SessionPlatformEnum.ios: 'ios',
  SessionPlatformEnum.android: 'android',
  SessionPlatformEnum.web: 'web',
};
