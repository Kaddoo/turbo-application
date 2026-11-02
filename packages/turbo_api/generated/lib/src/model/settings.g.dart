// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingsCWProxy {
  Settings announcement(HomeNoticeInput? announcement);

  Settings maxTripDistanceMeters(int maxTripDistanceMeters);

  Settings quoteTtlSeconds(int quoteTtlSeconds);

  Settings driverAckTimeoutSeconds(int driverAckTimeoutSeconds);

  Settings noDriverTimeoutSeconds(int noDriverTimeoutSeconds);

  Settings minTopupPesewas(int minTopupPesewas);

  Settings maxTopupPesewas(int maxTopupPesewas);

  Settings operatingHours(List<OperatingWindow>? operatingHours);

  Settings driverSilenceSeconds(int? driverSilenceSeconds);

  Settings noShowWaitSeconds(int? noShowWaitSeconds);

  Settings quoteLimitPerMinute(int? quoteLimitPerMinute);

  Settings smsDailyLimit(int? smsDailyLimit);

  Settings adjustmentApprovalThresholdPesewas(
    int? adjustmentApprovalThresholdPesewas,
  );

  Settings locationRetentionDays(int? locationRetentionDays);

  Settings bookingsPaused(bool? bookingsPaused);

  Settings pauseMessage(String? pauseMessage);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Settings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Settings(...).copyWith(id: 12, name: "My name")
  /// ````
  Settings call({
    HomeNoticeInput? announcement,
    int maxTripDistanceMeters,
    int quoteTtlSeconds,
    int driverAckTimeoutSeconds,
    int noDriverTimeoutSeconds,
    int minTopupPesewas,
    int maxTopupPesewas,
    List<OperatingWindow>? operatingHours,
    int? driverSilenceSeconds,
    int? noShowWaitSeconds,
    int? quoteLimitPerMinute,
    int? smsDailyLimit,
    int? adjustmentApprovalThresholdPesewas,
    int? locationRetentionDays,
    bool? bookingsPaused,
    String? pauseMessage,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettings.copyWith.fieldName(...)`
class _$SettingsCWProxyImpl implements _$SettingsCWProxy {
  const _$SettingsCWProxyImpl(this._value);

  final Settings _value;

  @override
  Settings announcement(HomeNoticeInput? announcement) =>
      this(announcement: announcement);

  @override
  Settings maxTripDistanceMeters(int maxTripDistanceMeters) =>
      this(maxTripDistanceMeters: maxTripDistanceMeters);

  @override
  Settings quoteTtlSeconds(int quoteTtlSeconds) =>
      this(quoteTtlSeconds: quoteTtlSeconds);

  @override
  Settings driverAckTimeoutSeconds(int driverAckTimeoutSeconds) =>
      this(driverAckTimeoutSeconds: driverAckTimeoutSeconds);

  @override
  Settings noDriverTimeoutSeconds(int noDriverTimeoutSeconds) =>
      this(noDriverTimeoutSeconds: noDriverTimeoutSeconds);

  @override
  Settings minTopupPesewas(int minTopupPesewas) =>
      this(minTopupPesewas: minTopupPesewas);

  @override
  Settings maxTopupPesewas(int maxTopupPesewas) =>
      this(maxTopupPesewas: maxTopupPesewas);

  @override
  Settings operatingHours(List<OperatingWindow>? operatingHours) =>
      this(operatingHours: operatingHours);

  @override
  Settings driverSilenceSeconds(int? driverSilenceSeconds) =>
      this(driverSilenceSeconds: driverSilenceSeconds);

  @override
  Settings noShowWaitSeconds(int? noShowWaitSeconds) =>
      this(noShowWaitSeconds: noShowWaitSeconds);

  @override
  Settings quoteLimitPerMinute(int? quoteLimitPerMinute) =>
      this(quoteLimitPerMinute: quoteLimitPerMinute);

  @override
  Settings smsDailyLimit(int? smsDailyLimit) =>
      this(smsDailyLimit: smsDailyLimit);

  @override
  Settings adjustmentApprovalThresholdPesewas(
    int? adjustmentApprovalThresholdPesewas,
  ) => this(
    adjustmentApprovalThresholdPesewas: adjustmentApprovalThresholdPesewas,
  );

  @override
  Settings locationRetentionDays(int? locationRetentionDays) =>
      this(locationRetentionDays: locationRetentionDays);

  @override
  Settings bookingsPaused(bool? bookingsPaused) =>
      this(bookingsPaused: bookingsPaused);

  @override
  Settings pauseMessage(String? pauseMessage) =>
      this(pauseMessage: pauseMessage);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Settings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Settings(...).copyWith(id: 12, name: "My name")
  /// ````
  Settings call({
    Object? announcement = const $CopyWithPlaceholder(),
    Object? maxTripDistanceMeters = const $CopyWithPlaceholder(),
    Object? quoteTtlSeconds = const $CopyWithPlaceholder(),
    Object? driverAckTimeoutSeconds = const $CopyWithPlaceholder(),
    Object? noDriverTimeoutSeconds = const $CopyWithPlaceholder(),
    Object? minTopupPesewas = const $CopyWithPlaceholder(),
    Object? maxTopupPesewas = const $CopyWithPlaceholder(),
    Object? operatingHours = const $CopyWithPlaceholder(),
    Object? driverSilenceSeconds = const $CopyWithPlaceholder(),
    Object? noShowWaitSeconds = const $CopyWithPlaceholder(),
    Object? quoteLimitPerMinute = const $CopyWithPlaceholder(),
    Object? smsDailyLimit = const $CopyWithPlaceholder(),
    Object? adjustmentApprovalThresholdPesewas = const $CopyWithPlaceholder(),
    Object? locationRetentionDays = const $CopyWithPlaceholder(),
    Object? bookingsPaused = const $CopyWithPlaceholder(),
    Object? pauseMessage = const $CopyWithPlaceholder(),
  }) {
    return Settings(
      announcement: announcement == const $CopyWithPlaceholder()
          ? _value.announcement
          // ignore: cast_nullable_to_non_nullable
          : announcement as HomeNoticeInput?,
      maxTripDistanceMeters:
          maxTripDistanceMeters == const $CopyWithPlaceholder()
          ? _value.maxTripDistanceMeters
          // ignore: cast_nullable_to_non_nullable
          : maxTripDistanceMeters as int,
      quoteTtlSeconds: quoteTtlSeconds == const $CopyWithPlaceholder()
          ? _value.quoteTtlSeconds
          // ignore: cast_nullable_to_non_nullable
          : quoteTtlSeconds as int,
      driverAckTimeoutSeconds:
          driverAckTimeoutSeconds == const $CopyWithPlaceholder()
          ? _value.driverAckTimeoutSeconds
          // ignore: cast_nullable_to_non_nullable
          : driverAckTimeoutSeconds as int,
      noDriverTimeoutSeconds:
          noDriverTimeoutSeconds == const $CopyWithPlaceholder()
          ? _value.noDriverTimeoutSeconds
          // ignore: cast_nullable_to_non_nullable
          : noDriverTimeoutSeconds as int,
      minTopupPesewas: minTopupPesewas == const $CopyWithPlaceholder()
          ? _value.minTopupPesewas
          // ignore: cast_nullable_to_non_nullable
          : minTopupPesewas as int,
      maxTopupPesewas: maxTopupPesewas == const $CopyWithPlaceholder()
          ? _value.maxTopupPesewas
          // ignore: cast_nullable_to_non_nullable
          : maxTopupPesewas as int,
      operatingHours: operatingHours == const $CopyWithPlaceholder()
          ? _value.operatingHours
          // ignore: cast_nullable_to_non_nullable
          : operatingHours as List<OperatingWindow>?,
      driverSilenceSeconds: driverSilenceSeconds == const $CopyWithPlaceholder()
          ? _value.driverSilenceSeconds
          // ignore: cast_nullable_to_non_nullable
          : driverSilenceSeconds as int?,
      noShowWaitSeconds: noShowWaitSeconds == const $CopyWithPlaceholder()
          ? _value.noShowWaitSeconds
          // ignore: cast_nullable_to_non_nullable
          : noShowWaitSeconds as int?,
      quoteLimitPerMinute: quoteLimitPerMinute == const $CopyWithPlaceholder()
          ? _value.quoteLimitPerMinute
          // ignore: cast_nullable_to_non_nullable
          : quoteLimitPerMinute as int?,
      smsDailyLimit: smsDailyLimit == const $CopyWithPlaceholder()
          ? _value.smsDailyLimit
          // ignore: cast_nullable_to_non_nullable
          : smsDailyLimit as int?,
      adjustmentApprovalThresholdPesewas:
          adjustmentApprovalThresholdPesewas == const $CopyWithPlaceholder()
          ? _value.adjustmentApprovalThresholdPesewas
          // ignore: cast_nullable_to_non_nullable
          : adjustmentApprovalThresholdPesewas as int?,
      locationRetentionDays:
          locationRetentionDays == const $CopyWithPlaceholder()
          ? _value.locationRetentionDays
          // ignore: cast_nullable_to_non_nullable
          : locationRetentionDays as int?,
      bookingsPaused: bookingsPaused == const $CopyWithPlaceholder()
          ? _value.bookingsPaused
          // ignore: cast_nullable_to_non_nullable
          : bookingsPaused as bool?,
      pauseMessage: pauseMessage == const $CopyWithPlaceholder()
          ? _value.pauseMessage
          // ignore: cast_nullable_to_non_nullable
          : pauseMessage as String?,
    );
  }
}

extension $SettingsCopyWith on Settings {
  /// Returns a callable class that can be used as follows: `instanceOfSettings.copyWith(...)` or like so:`instanceOfSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingsCWProxy get copyWith => _$SettingsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Settings', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'maxTripDistanceMeters',
          'quoteTtlSeconds',
          'driverAckTimeoutSeconds',
          'noDriverTimeoutSeconds',
          'minTopupPesewas',
          'maxTopupPesewas',
        ],
      );
      final val = Settings(
        announcement: $checkedConvert(
          'announcement',
          (v) => v == null
              ? null
              : HomeNoticeInput.fromJson(v as Map<String, dynamic>),
        ),
        maxTripDistanceMeters: $checkedConvert(
          'maxTripDistanceMeters',
          (v) => (v as num?)?.toInt() ?? 18000,
        ),
        quoteTtlSeconds: $checkedConvert(
          'quoteTtlSeconds',
          (v) => (v as num?)?.toInt() ?? 300,
        ),
        driverAckTimeoutSeconds: $checkedConvert(
          'driverAckTimeoutSeconds',
          (v) => (v as num?)?.toInt() ?? 45,
        ),
        noDriverTimeoutSeconds: $checkedConvert(
          'noDriverTimeoutSeconds',
          (v) => (v as num?)?.toInt() ?? 300,
        ),
        minTopupPesewas: $checkedConvert(
          'minTopupPesewas',
          (v) => (v as num).toInt(),
        ),
        maxTopupPesewas: $checkedConvert(
          'maxTopupPesewas',
          (v) => (v as num).toInt(),
        ),
        operatingHours: $checkedConvert(
          'operatingHours',
          (v) => (v as List<dynamic>?)
              ?.map((e) => OperatingWindow.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        driverSilenceSeconds: $checkedConvert(
          'driverSilenceSeconds',
          (v) => (v as num?)?.toInt() ?? 180,
        ),
        noShowWaitSeconds: $checkedConvert(
          'noShowWaitSeconds',
          (v) => (v as num?)?.toInt() ?? 300,
        ),
        quoteLimitPerMinute: $checkedConvert(
          'quoteLimitPerMinute',
          (v) => (v as num?)?.toInt() ?? 10,
        ),
        smsDailyLimit: $checkedConvert(
          'smsDailyLimit',
          (v) => (v as num?)?.toInt() ?? 500,
        ),
        adjustmentApprovalThresholdPesewas: $checkedConvert(
          'adjustmentApprovalThresholdPesewas',
          (v) => (v as num?)?.toInt() ?? 5000,
        ),
        locationRetentionDays: $checkedConvert(
          'locationRetentionDays',
          (v) => (v as num?)?.toInt() ?? 90,
        ),
        bookingsPaused: $checkedConvert(
          'bookingsPaused',
          (v) => v as bool? ?? false,
        ),
        pauseMessage: $checkedConvert('pauseMessage', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'announcement': ?instance.announcement?.toJson(),
  'maxTripDistanceMeters': instance.maxTripDistanceMeters,
  'quoteTtlSeconds': instance.quoteTtlSeconds,
  'driverAckTimeoutSeconds': instance.driverAckTimeoutSeconds,
  'noDriverTimeoutSeconds': instance.noDriverTimeoutSeconds,
  'minTopupPesewas': instance.minTopupPesewas,
  'maxTopupPesewas': instance.maxTopupPesewas,
  'operatingHours': ?instance.operatingHours?.map((e) => e.toJson()).toList(),
  'driverSilenceSeconds': ?instance.driverSilenceSeconds,
  'noShowWaitSeconds': ?instance.noShowWaitSeconds,
  'quoteLimitPerMinute': ?instance.quoteLimitPerMinute,
  'smsDailyLimit': ?instance.smsDailyLimit,
  'adjustmentApprovalThresholdPesewas':
      ?instance.adjustmentApprovalThresholdPesewas,
  'locationRetentionDays': ?instance.locationRetentionDays,
  'bookingsPaused': ?instance.bookingsPaused,
  'pauseMessage': ?instance.pauseMessage,
};
