// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_event.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RideEventCWProxy {
  RideEvent at(DateTime at);

  RideEvent type(String type);

  RideEvent actor(String actor);

  RideEvent detail(String? detail);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideEvent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideEvent(...).copyWith(id: 12, name: "My name")
  /// ````
  RideEvent call({DateTime at, String type, String actor, String? detail});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRideEvent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRideEvent.copyWith.fieldName(...)`
class _$RideEventCWProxyImpl implements _$RideEventCWProxy {
  const _$RideEventCWProxyImpl(this._value);

  final RideEvent _value;

  @override
  RideEvent at(DateTime at) => this(at: at);

  @override
  RideEvent type(String type) => this(type: type);

  @override
  RideEvent actor(String actor) => this(actor: actor);

  @override
  RideEvent detail(String? detail) => this(detail: detail);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RideEvent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RideEvent(...).copyWith(id: 12, name: "My name")
  /// ````
  RideEvent call({
    Object? at = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? actor = const $CopyWithPlaceholder(),
    Object? detail = const $CopyWithPlaceholder(),
  }) {
    return RideEvent(
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      actor: actor == const $CopyWithPlaceholder()
          ? _value.actor
          // ignore: cast_nullable_to_non_nullable
          : actor as String,
      detail: detail == const $CopyWithPlaceholder()
          ? _value.detail
          // ignore: cast_nullable_to_non_nullable
          : detail as String?,
    );
  }
}

extension $RideEventCopyWith on RideEvent {
  /// Returns a callable class that can be used as follows: `instanceOfRideEvent.copyWith(...)` or like so:`instanceOfRideEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RideEventCWProxy get copyWith => _$RideEventCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideEvent _$RideEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RideEvent', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['at', 'type', 'actor']);
      final val = RideEvent(
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        type: $checkedConvert('type', (v) => v as String),
        actor: $checkedConvert('actor', (v) => v as String),
        detail: $checkedConvert('detail', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RideEventToJson(RideEvent instance) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'type': instance.type,
  'actor': instance.actor,
  'detail': ?instance.detail,
};
