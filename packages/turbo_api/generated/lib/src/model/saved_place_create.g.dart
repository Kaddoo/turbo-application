// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_place_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SavedPlaceCreateCWProxy {
  SavedPlaceCreate label(String label);

  SavedPlaceCreate location(Location location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlaceCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlaceCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlaceCreate call({String label, Location location});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSavedPlaceCreate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSavedPlaceCreate.copyWith.fieldName(...)`
class _$SavedPlaceCreateCWProxyImpl implements _$SavedPlaceCreateCWProxy {
  const _$SavedPlaceCreateCWProxyImpl(this._value);

  final SavedPlaceCreate _value;

  @override
  SavedPlaceCreate label(String label) => this(label: label);

  @override
  SavedPlaceCreate location(Location location) => this(location: location);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlaceCreate(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlaceCreate(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlaceCreate call({
    Object? label = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
  }) {
    return SavedPlaceCreate(
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as Location,
    );
  }
}

extension $SavedPlaceCreateCopyWith on SavedPlaceCreate {
  /// Returns a callable class that can be used as follows: `instanceOfSavedPlaceCreate.copyWith(...)` or like so:`instanceOfSavedPlaceCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SavedPlaceCreateCWProxy get copyWith => _$SavedPlaceCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedPlaceCreate _$SavedPlaceCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SavedPlaceCreate', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['label', 'location']);
      final val = SavedPlaceCreate(
        label: $checkedConvert('label', (v) => v as String),
        location: $checkedConvert(
          'location',
          (v) => Location.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SavedPlaceCreateToJson(SavedPlaceCreate instance) =>
    <String, dynamic>{
      'label': instance.label,
      'location': instance.location.toJson(),
    };
