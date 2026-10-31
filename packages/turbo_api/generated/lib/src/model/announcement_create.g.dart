// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AnnouncementCreateCWProxy {
  AnnouncementCreate audience(AnnouncementCreateAudienceEnum audience);

  AnnouncementCreate title(String title);

  AnnouncementCreate body(String body);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AnnouncementCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AnnouncementCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  AnnouncementCreate call({
    AnnouncementCreateAudienceEnum audience,
    String title,
    String body,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAnnouncementCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAnnouncementCreate.copyWith.fieldName(...)`
class _$AnnouncementCreateCWProxyImpl implements _$AnnouncementCreateCWProxy {
  const _$AnnouncementCreateCWProxyImpl(this._value);

  final AnnouncementCreate _value;

  @override
  AnnouncementCreate audience(AnnouncementCreateAudienceEnum audience) =>
      this(audience: audience);

  @override
  AnnouncementCreate title(String title) => this(title: title);

  @override
  AnnouncementCreate body(String body) => this(body: body);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AnnouncementCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AnnouncementCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  AnnouncementCreate call({
    Object? audience = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
  }) {
    return AnnouncementCreate(
      audience: audience == const $CopyWithPlaceholder()
          ? _value.audience
          // ignore: cast_nullable_to_non_nullable
          : audience as AnnouncementCreateAudienceEnum,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
    );
  }
}

extension $AnnouncementCreateCopyWith on AnnouncementCreate {
  /// Returns a callable class that can be used as follows: `instanceOfAnnouncementCreate.copyWith(...)` or like so:`instanceOfAnnouncementCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AnnouncementCreateCWProxy get copyWith =>
      _$AnnouncementCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementCreate _$AnnouncementCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AnnouncementCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['audience', 'title', 'body']);
      final val = AnnouncementCreate(
        audience: $checkedConvert(
          'audience',
          (v) => $enumDecode(_$AnnouncementCreateAudienceEnumEnumMap, v),
        ),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AnnouncementCreateToJson(AnnouncementCreate instance) =>
    <String, dynamic>{
      'audience': _$AnnouncementCreateAudienceEnumEnumMap[instance.audience]!,
      'title': instance.title,
      'body': instance.body,
    };

const _$AnnouncementCreateAudienceEnumEnumMap = {
  AnnouncementCreateAudienceEnum.students: 'students',
  AnnouncementCreateAudienceEnum.drivers: 'drivers',
  AnnouncementCreateAudienceEnum.all: 'all',
};
