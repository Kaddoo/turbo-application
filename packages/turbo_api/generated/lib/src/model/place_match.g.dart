// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_match.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PlaceMatchCWProxy {
  PlaceMatch placeId(String placeId);

  PlaceMatch label(String label);

  PlaceMatch landmark(String? landmark);

  PlaceMatch isPickupPoint(bool isPickupPoint);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceMatch(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceMatch(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceMatch call({
    String placeId,
    String label,
    String? landmark,
    bool isPickupPoint,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPlaceMatch.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPlaceMatch.copyWith.fieldName(...)`
class _$PlaceMatchCWProxyImpl implements _$PlaceMatchCWProxy {
  const _$PlaceMatchCWProxyImpl(this._value);

  final PlaceMatch _value;

  @override
  PlaceMatch placeId(String placeId) => this(placeId: placeId);

  @override
  PlaceMatch label(String label) => this(label: label);

  @override
  PlaceMatch landmark(String? landmark) => this(landmark: landmark);

  @override
  PlaceMatch isPickupPoint(bool isPickupPoint) =>
      this(isPickupPoint: isPickupPoint);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceMatch(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceMatch(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceMatch call({
    Object? placeId = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? landmark = const $CopyWithPlaceholder(),
    Object? isPickupPoint = const $CopyWithPlaceholder(),
  }) {
    return PlaceMatch(
      placeId: placeId == const $CopyWithPlaceholder()
          ? _value.placeId
          // ignore: cast_nullable_to_non_nullable
          : placeId as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      landmark: landmark == const $CopyWithPlaceholder()
          ? _value.landmark
          // ignore: cast_nullable_to_non_nullable
          : landmark as String?,
      isPickupPoint: isPickupPoint == const $CopyWithPlaceholder()
          ? _value.isPickupPoint
          // ignore: cast_nullable_to_non_nullable
          : isPickupPoint as bool,
    );
  }
}

extension $PlaceMatchCopyWith on PlaceMatch {
  /// Returns a callable class that can be used as follows: `instanceOfPlaceMatch.copyWith(...)` or like so:`instanceOfPlaceMatch.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PlaceMatchCWProxy get copyWith => _$PlaceMatchCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceMatch _$PlaceMatchFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PlaceMatch',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['placeId', 'label', 'isPickupPoint']);
    final val = PlaceMatch(
      placeId: $checkedConvert('placeId', (v) => v as String),
      label: $checkedConvert('label', (v) => v as String),
      landmark: $checkedConvert('landmark', (v) => v as String?),
      isPickupPoint: $checkedConvert('isPickupPoint', (v) => v as bool),
    );
    return val;
  },
);

Map<String, dynamic> _$PlaceMatchToJson(PlaceMatch instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'label': instance.label,
      'landmark': ?instance.landmark,
      'isPickupPoint': instance.isPickupPoint,
    };
