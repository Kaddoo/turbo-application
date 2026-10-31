// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AnnouncementCWProxy {
  Announcement id(String id);

  Announcement audience(String audience);

  Announcement title(String title);

  Announcement body(String body);

  Announcement sentBy(String sentBy);

  Announcement recipientCount(int? recipientCount);

  Announcement createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Announcement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Announcement(...).copyWith(id: 12, name: "My name")
  /// ````
  Announcement call({
    String id,
    String audience,
    String title,
    String body,
    String sentBy,
    int? recipientCount,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAnnouncement.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAnnouncement.copyWith.fieldName(...)`
class _$AnnouncementCWProxyImpl implements _$AnnouncementCWProxy {
  const _$AnnouncementCWProxyImpl(this._value);

  final Announcement _value;

  @override
  Announcement id(String id) => this(id: id);

  @override
  Announcement audience(String audience) => this(audience: audience);

  @override
  Announcement title(String title) => this(title: title);

  @override
  Announcement body(String body) => this(body: body);

  @override
  Announcement sentBy(String sentBy) => this(sentBy: sentBy);

  @override
  Announcement recipientCount(int? recipientCount) =>
      this(recipientCount: recipientCount);

  @override
  Announcement createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Announcement(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Announcement(...).copyWith(id: 12, name: "My name")
  /// ````
  Announcement call({
    Object? id = const $CopyWithPlaceholder(),
    Object? audience = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? sentBy = const $CopyWithPlaceholder(),
    Object? recipientCount = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return Announcement(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      audience: audience == const $CopyWithPlaceholder()
          ? _value.audience
          // ignore: cast_nullable_to_non_nullable
          : audience as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      sentBy: sentBy == const $CopyWithPlaceholder()
          ? _value.sentBy
          // ignore: cast_nullable_to_non_nullable
          : sentBy as String,
      recipientCount: recipientCount == const $CopyWithPlaceholder()
          ? _value.recipientCount
          // ignore: cast_nullable_to_non_nullable
          : recipientCount as int?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AnnouncementCopyWith on Announcement {
  /// Returns a callable class that can be used as follows: `instanceOfAnnouncement.copyWith(...)` or like so:`instanceOfAnnouncement.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AnnouncementCWProxy get copyWith => _$AnnouncementCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Announcement', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'audience',
          'title',
          'body',
          'sentBy',
          'createdAt',
        ],
      );
      final val = Announcement(
        id: $checkedConvert('id', (v) => v as String),
        audience: $checkedConvert('audience', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        sentBy: $checkedConvert('sentBy', (v) => v as String),
        recipientCount: $checkedConvert(
          'recipientCount',
          (v) => (v as num?)?.toInt(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'audience': instance.audience,
      'title': instance.title,
      'body': instance.body,
      'sentBy': instance.sentBy,
      'recipientCount': ?instance.recipientCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
