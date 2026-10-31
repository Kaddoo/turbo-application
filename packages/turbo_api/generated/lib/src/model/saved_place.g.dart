// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_place.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SavedPlaceCWProxy {
  SavedPlace id(String id);

  SavedPlace label(String label);

  SavedPlace location(Location location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlace(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlace(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlace call({String id, String label, Location location});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSavedPlace.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSavedPlace.copyWith.fieldName(...)`
class _$SavedPlaceCWProxyImpl implements _$SavedPlaceCWProxy {
  const _$SavedPlaceCWProxyImpl(this._value);

  final SavedPlace _value;

  @override
  SavedPlace id(String id) => this(id: id);

  @override
  SavedPlace label(String label) => this(label: label);

  @override
  SavedPlace location(Location location) => this(location: location);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlace(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlace(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlace call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
  }) {
    return SavedPlace(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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

extension $SavedPlaceCopyWith on SavedPlace {
  /// Returns a callable class that can be used as follows: `instanceOfSavedPlace.copyWith(...)` or like so:`instanceOfSavedPlace.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SavedPlaceCWProxy get copyWith => _$SavedPlaceCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedPlace _$SavedPlaceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SavedPlace', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'label', 'location']);
      final val = SavedPlace(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        location: $checkedConvert(
          'location',
          (v) => Location.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SavedPlaceToJson(SavedPlace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'location': instance.location.toJson(),
    };
