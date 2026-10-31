// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_location.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TripLocationCWProxy {
  TripLocation location(GeoPoint? location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TripLocation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TripLocation(...).copyWith(id: 12, name: "My name")
  /// ````
  TripLocation call({GeoPoint? location});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTripLocation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTripLocation.copyWith.fieldName(...)`
class _$TripLocationCWProxyImpl implements _$TripLocationCWProxy {
  const _$TripLocationCWProxyImpl(this._value);

  final TripLocation _value;

  @override
  TripLocation location(GeoPoint? location) => this(location: location);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TripLocation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TripLocation(...).copyWith(id: 12, name: "My name")
  /// ````
  TripLocation call({Object? location = const $CopyWithPlaceholder()}) {
    return TripLocation(
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as GeoPoint?,
    );
  }
}

extension $TripLocationCopyWith on TripLocation {
  /// Returns a callable class that can be used as follows: `instanceOfTripLocation.copyWith(...)` or like so:`instanceOfTripLocation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TripLocationCWProxy get copyWith => _$TripLocationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripLocation _$TripLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TripLocation', json, ($checkedConvert) {
      final val = TripLocation(
        location: $checkedConvert(
          'location',
          (v) =>
              v == null ? null : GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TripLocationToJson(TripLocation instance) =>
    <String, dynamic>{'location': ?instance.location?.toJson()};
