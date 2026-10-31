// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_contact.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrustedContactCWProxy {
  TrustedContact id(String id);

  TrustedContact name(String name);

  TrustedContact phone(String phone);

  TrustedContact relationship(String? relationship);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContact(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContact(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContact call({
    String id,
    String name,
    String phone,
    String? relationship,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrustedContact.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrustedContact.copyWith.fieldName(...)`
class _$TrustedContactCWProxyImpl implements _$TrustedContactCWProxy {
  const _$TrustedContactCWProxyImpl(this._value);

  final TrustedContact _value;

  @override
  TrustedContact id(String id) => this(id: id);

  @override
  TrustedContact name(String name) => this(name: name);

  @override
  TrustedContact phone(String phone) => this(phone: phone);

  @override
  TrustedContact relationship(String? relationship) =>
      this(relationship: relationship);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrustedContact(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrustedContact(...).copyWith(id: 12, name: "My name")
  /// ````
  TrustedContact call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? relationship = const $CopyWithPlaceholder(),
  }) {
    return TrustedContact(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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

extension $TrustedContactCopyWith on TrustedContact {
  /// Returns a callable class that can be used as follows: `instanceOfTrustedContact.copyWith(...)` or like so:`instanceOfTrustedContact.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrustedContactCWProxy get copyWith => _$TrustedContactCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustedContact _$TrustedContactFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrustedContact', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'phone']);
      final val = TrustedContact(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        relationship: $checkedConvert('relationship', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$TrustedContactToJson(TrustedContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'relationship': ?instance.relationship,
    };
