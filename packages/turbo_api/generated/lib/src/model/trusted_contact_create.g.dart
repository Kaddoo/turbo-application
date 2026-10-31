// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_contact_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrustedContactCreateCWProxy {
  TrustedContactCreate name(String name);

  TrustedContactCreate phone(String phone);

  TrustedContactCreate relationship(String? relationship);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContactCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContactCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContactCreate call({String name, String phone, String? relationship});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrustedContactCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrustedContactCreate.copyWith.fieldName(...)`
class _$TrustedContactCreateCWProxyImpl
    implements _$TrustedContactCreateCWProxy {
  const _$TrustedContactCreateCWProxyImpl(this._value);

  final TrustedContactCreate _value;

  @override
  TrustedContactCreate name(String name) => this(name: name);

  @override
  TrustedContactCreate phone(String phone) => this(phone: phone);

  @override
  TrustedContactCreate relationship(String? relationship) =>
      this(relationship: relationship);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContactCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContactCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContactCreate call({
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? relationship = const $CopyWithPlaceholder(),
  }) {
    return TrustedContactCreate(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      relationship: relationship == const $CopyWithPlaceholder()
          ? _value.relationship
          // ignore: cast_nullable_to_non_nullable
          : relationship as String?,
    );
  }
}

extension $TrustedContactCreateCopyWith on TrustedContactCreate {
  /// Returns a callable class that can be used as follows: `instanceOfTrustedContactCreate.copyWith(...)` or like so:`instanceOfTrustedContactCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrustedContactCreateCWProxy get copyWith =>
      _$TrustedContactCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustedContactCreate _$TrustedContactCreateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TrustedContactCreate', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['name', 'phone']);
  final val = TrustedContactCreate(
    name: $checkedConvert('name', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    relationship: $checkedConvert('relationship', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$TrustedContactCreateToJson(
  TrustedContactCreate instance,
) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'relationship': ?instance.relationship,
};
