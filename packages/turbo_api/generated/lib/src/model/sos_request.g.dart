// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SosRequestCWProxy {
  SosRequest rideId(String? rideId);

  SosRequest location(GeoPoint location);

  SosRequest note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SosRequest call({String? rideId, GeoPoint location, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSosRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSosRequest.copyWith.fieldName(...)`
class _$SosRequestCWProxyImpl implements _$SosRequestCWProxy {
  const _$SosRequestCWProxyImpl(this._value);

  final SosRequest _value;

  @override
  SosRequest rideId(String? rideId) => this(rideId: rideId);

  @override
  SosRequest location(GeoPoint location) => this(location: location);

  @override
  SosRequest note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  SosRequest call({
    Object? rideId = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return SosRequest(
      rideId: rideId == const $CopyWithPlaceholder()
          ? _value.rideId
          // ignore: cast_nullable_to_non_nullable
          : rideId as String?,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as GeoPoint,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $SosRequestCopyWith on SosRequest {
  /// Returns a callable class that can be used as follows: `instanceOfSosRequest.copyWith(...)` or like so:`instanceOfSosRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SosRequestCWProxy get copyWith => _$SosRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosRequest _$SosRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SosRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['location']);
      final val = SosRequest(
        rideId: $checkedConvert('rideId', (v) => v as String?),
        location: $checkedConvert(
          'location',
          (v) => GeoPoint.fromJson(v as Map<String, dynamic>),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SosRequestToJson(SosRequest instance) =>
    <String, dynamic>{
      'rideId': ?instance.rideId,
      'location': instance.location.toJson(),
      'note': ?instance.note,
    };
