// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_public.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DriverPublicCWProxy {
  DriverPublic id(String id);

  DriverPublic firstName(String firstName);

  DriverPublic photoUrl(String? photoUrl);

  DriverPublic averageRating(num? averageRating);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverPublic(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverPublic(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverPublic call({
    String id,
    String firstName,
    String? photoUrl,
    num? averageRating,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDriverPublic.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDriverPublic.copyWith.fieldName(...)`
class _$DriverPublicCWProxyImpl implements _$DriverPublicCWProxy {
  const _$DriverPublicCWProxyImpl(this._value);

  final DriverPublic _value;

  @override
  DriverPublic id(String id) => this(id: id);

  @override
  DriverPublic firstName(String firstName) => this(firstName: firstName);

  @override
  DriverPublic photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  DriverPublic averageRating(num? averageRating) =>
      this(averageRating: averageRating);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DriverPublic(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DriverPublic(...).copyWith(id: 12, name: "My name")
  /// ````
  DriverPublic call({
    Object? id = const $CopyWithPlaceholder(),
    Object? firstName = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? averageRating = const $CopyWithPlaceholder(),
  }) {
    return DriverPublic(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      firstName: firstName == const $CopyWithPlaceholder()
          ? _value.firstName
          // ignore: cast_nullable_to_non_nullable
          : firstName as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      averageRating: averageRating == const $CopyWithPlaceholder()
          ? _value.averageRating
          // ignore: cast_nullable_to_non_nullable
          : averageRating as num?,
    );
  }
}

extension $DriverPublicCopyWith on DriverPublic {
  /// Returns a callable class that can be used as follows: `instanceOfDriverPublic.copyWith(...)` or like so:`instanceOfDriverPublic.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DriverPublicCWProxy get copyWith => _$DriverPublicCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverPublic _$DriverPublicFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DriverPublic', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'firstName']);
      final val = DriverPublic(
        id: $checkedConvert('id', (v) => v as String),
        firstName: $checkedConvert('firstName', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        averageRating: $checkedConvert('averageRating', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$DriverPublicToJson(DriverPublic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'photoUrl': ?instance.photoUrl,
      'averageRating': ?instance.averageRating,
    };
