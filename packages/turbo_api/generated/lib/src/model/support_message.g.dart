// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportMessageCWProxy {
  SupportMessage id(String id);

  SupportMessage author(SupportMessageAuthorEnum author);

  SupportMessage body(String body);

  SupportMessage internal(bool? internal);

  SupportMessage createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportMessage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportMessage(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportMessage call({
    String id,
    SupportMessageAuthorEnum author,
    String body,
    bool? internal,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportMessage.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportMessage.copyWith.fieldName(...)`
class _$SupportMessageCWProxyImpl implements _$SupportMessageCWProxy {
  const _$SupportMessageCWProxyImpl(this._value);

  final SupportMessage _value;

  @override
  SupportMessage id(String id) => this(id: id);

  @override
  SupportMessage author(SupportMessageAuthorEnum author) =>
      this(author: author);

  @override
  SupportMessage body(String body) => this(body: body);

  @override
  SupportMessage internal(bool? internal) => this(internal: internal);

  @override
  SupportMessage createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportMessage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportMessage(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportMessage call({
    Object? id = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? internal = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return SupportMessage(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as SupportMessageAuthorEnum,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      internal: internal == const $CopyWithPlaceholder()
          ? _value.internal
          // ignore: cast_nullable_to_non_nullable
          : internal as bool?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $SupportMessageCopyWith on SupportMessage {
  /// Returns a callable class that can be used as follows: `instanceOfSupportMessage.copyWith(...)` or like so:`instanceOfSupportMessage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportMessageCWProxy get copyWith => _$SupportMessageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportMessage _$SupportMessageFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SupportMessage', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'author', 'body', 'createdAt']);
  final val = SupportMessage(
    id: $checkedConvert('id', (v) => v as String),
    author: $checkedConvert(
      'author',
      (v) => $enumDecode(_$SupportMessageAuthorEnumEnumMap, v),
    ),
    body: $checkedConvert('body', (v) => v as String),
    internal: $checkedConvert('internal', (v) => v as bool?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$SupportMessageToJson(SupportMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': _$SupportMessageAuthorEnumEnumMap[instance.author]!,
      'body': instance.body,
      'internal': ?instance.internal,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SupportMessageAuthorEnumEnumMap = {
  SupportMessageAuthorEnum.user: 'user',
  SupportMessageAuthorEnum.staff: 'staff',
};
