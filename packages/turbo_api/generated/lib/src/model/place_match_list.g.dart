// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_match_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PlaceMatchListCWProxy {
  PlaceMatchList items(List<PlaceMatch> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceMatchList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceMatchList(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceMatchList call({List<PlaceMatch> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPlaceMatchList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPlaceMatchList.copyWith.fieldName(...)`
class _$PlaceMatchListCWProxyImpl implements _$PlaceMatchListCWProxy {
  const _$PlaceMatchListCWProxyImpl(this._value);

  final PlaceMatchList _value;

  @override
  PlaceMatchList items(List<PlaceMatch> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceMatchList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceMatchList(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceMatchList call({Object? items = const $CopyWithPlaceholder()}) {
    return PlaceMatchList(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PlaceMatch>,
    );
  }
}

extension $PlaceMatchListCopyWith on PlaceMatchList {
  /// Returns a callable class that can be used as follows: `instanceOfPlaceMatchList.copyWith(...)` or like so:`instanceOfPlaceMatchList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PlaceMatchListCWProxy get copyWith => _$PlaceMatchListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceMatchList _$PlaceMatchListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlaceMatchList', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = PlaceMatchList(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PlaceMatch.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PlaceMatchListToJson(PlaceMatchList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
