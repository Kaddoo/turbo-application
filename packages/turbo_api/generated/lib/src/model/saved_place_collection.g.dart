// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_place_collection.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SavedPlaceCollectionCWProxy {
  SavedPlaceCollection data(List<SavedPlace> data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlaceCollection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlaceCollection(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlaceCollection call({List<SavedPlace> data});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSavedPlaceCollection.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSavedPlaceCollection.copyWith.fieldName(...)`
class _$SavedPlaceCollectionCWProxyImpl
    implements _$SavedPlaceCollectionCWProxy {
  const _$SavedPlaceCollectionCWProxyImpl(this._value);

  final SavedPlaceCollection _value;

  @override
  SavedPlaceCollection data(List<SavedPlace> data) => this(data: data);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedPlaceCollection(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedPlaceCollection(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedPlaceCollection call({Object? data = const $CopyWithPlaceholder()}) {
    return SavedPlaceCollection(
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as List<SavedPlace>,
    );
  }
}

extension $SavedPlaceCollectionCopyWith on SavedPlaceCollection {
  /// Returns a callable class that can be used as follows: `instanceOfSavedPlaceCollection.copyWith(...)` or like so:`instanceOfSavedPlaceCollection.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SavedPlaceCollectionCWProxy get copyWith =>
      _$SavedPlaceCollectionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedPlaceCollection _$SavedPlaceCollectionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SavedPlaceCollection', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['data']);
  final val = SavedPlaceCollection(
    data: $checkedConvert(
      'data',
      (v) => (v as List<dynamic>)
          .map((e) => SavedPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$SavedPlaceCollectionToJson(
  SavedPlaceCollection instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
