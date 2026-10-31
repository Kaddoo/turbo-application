// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_share.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TripShareCWProxy {
  TripShare shareUrl(String shareUrl);

  TripShare expiresAt(DateTime expiresAt);

  TripShare notifiedContactIds(List<String>? notifiedContactIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TripShare(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TripShare(...).copyWith(id: 12, name: "My name")
  /// ````
  TripShare call({
    String shareUrl,
    DateTime expiresAt,
    List<String>? notifiedContactIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTripShare.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTripShare.copyWith.fieldName(...)`
class _$TripShareCWProxyImpl implements _$TripShareCWProxy {
  const _$TripShareCWProxyImpl(this._value);

  final TripShare _value;

  @override
  TripShare shareUrl(String shareUrl) => this(shareUrl: shareUrl);

  @override
  TripShare expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  TripShare notifiedContactIds(List<String>? notifiedContactIds) =>
      this(notifiedContactIds: notifiedContactIds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TripShare(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TripShare(...).copyWith(id: 12, name: "My name")
  /// ````
  TripShare call({
    Object? shareUrl = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? notifiedContactIds = const $CopyWithPlaceholder(),
  }) {
    return TripShare(
      shareUrl: shareUrl == const $CopyWithPlaceholder()
          ? _value.shareUrl
          // ignore: cast_nullable_to_non_nullable
          : shareUrl as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
      notifiedContactIds: notifiedContactIds == const $CopyWithPlaceholder()
          ? _value.notifiedContactIds
          // ignore: cast_nullable_to_non_nullable
          : notifiedContactIds as List<String>?,
    );
  }
}

extension $TripShareCopyWith on TripShare {
  /// Returns a callable class that can be used as follows: `instanceOfTripShare.copyWith(...)` or like so:`instanceOfTripShare.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TripShareCWProxy get copyWith => _$TripShareCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripShare _$TripShareFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TripShare', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['shareUrl', 'expiresAt']);
      final val = TripShare(
        shareUrl: $checkedConvert('shareUrl', (v) => v as String),
        expiresAt: $checkedConvert(
          'expiresAt',
          (v) => DateTime.parse(v as String),
        ),
        notifiedContactIds: $checkedConvert(
          'notifiedContactIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TripShareToJson(TripShare instance) => <String, dynamic>{
  'shareUrl': instance.shareUrl,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'notifiedContactIds': ?instance.notifiedContactIds,
};
