// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_message_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SupportMessageCreateCWProxy {
  SupportMessageCreate body(String body);

  SupportMessageCreate internal(bool? internal);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportMessageCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportMessageCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportMessageCreate call({String body, bool? internal});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSupportMessageCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSupportMessageCreate.copyWith.fieldName(...)`
class _$SupportMessageCreateCWProxyImpl
    implements _$SupportMessageCreateCWProxy {
  const _$SupportMessageCreateCWProxyImpl(this._value);

  final SupportMessageCreate _value;

  @override
  SupportMessageCreate body(String body) => this(body: body);

  @override
  SupportMessageCreate internal(bool? internal) => this(internal: internal);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SupportMessageCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SupportMessageCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SupportMessageCreate call({
    Object? body = const $CopyWithPlaceholder(),
    Object? internal = const $CopyWithPlaceholder(),
  }) {
    return SupportMessageCreate(
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      internal: internal == const $CopyWithPlaceholder()
          ? _value.internal
          // ignore: cast_nullable_to_non_nullable
          : internal as bool?,
    );
  }
}

extension $SupportMessageCreateCopyWith on SupportMessageCreate {
  /// Returns a callable class that can be used as follows: `instanceOfSupportMessageCreate.copyWith(...)` or like so:`instanceOfSupportMessageCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SupportMessageCreateCWProxy get copyWith =>
      _$SupportMessageCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportMessageCreate _$SupportMessageCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SupportMessageCreate', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['body']);
  final val = SupportMessageCreate(
    body: $checkedConvert('body', (v) => v as String),
    internal: $checkedConvert('internal', (v) => v as bool? ?? false),
  );
  return val;
});

Map<String, dynamic> _$SupportMessageCreateToJson(
  SupportMessageCreate instance,
) => <String, dynamic>{'body': instance.body, 'internal': ?instance.internal};
