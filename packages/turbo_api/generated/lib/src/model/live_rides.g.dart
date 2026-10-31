// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_rides.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveRidesCWProxy {
  LiveRides rides(List<LiveRidesRidesInner> rides);

  LiveRides onDutyDrivers(List<LiveRidesOnDutyDriversInner> onDutyDrivers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRides(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRides(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRides call({
    List<LiveRidesRidesInner> rides,
    List<LiveRidesOnDutyDriversInner> onDutyDrivers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveRides.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLiveRides.copyWith.fieldName(...)`
class _$LiveRidesCWProxyImpl implements _$LiveRidesCWProxy {
  const _$LiveRidesCWProxyImpl(this._value);

  final LiveRides _value;

  @override
  LiveRides rides(List<LiveRidesRidesInner> rides) => this(rides: rides);

  @override
  LiveRides onDutyDrivers(List<LiveRidesOnDutyDriversInner> onDutyDrivers) =>
      this(onDutyDrivers: onDutyDrivers);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveRides(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveRides(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveRides call({
    Object? rides = const $CopyWithPlaceholder(),
    Object? onDutyDrivers = const $CopyWithPlaceholder(),
  }) {
    return LiveRides(
      rides: rides == const $CopyWithPlaceholder()
          ? _value.rides
          // ignore: cast_nullable_to_non_nullable
          : rides as List<LiveRidesRidesInner>,
      onDutyDrivers: onDutyDrivers == const $CopyWithPlaceholder()
          ? _value.onDutyDrivers
          // ignore: cast_nullable_to_non_nullable
          : onDutyDrivers as List<LiveRidesOnDutyDriversInner>,
    );
  }
}

extension $LiveRidesCopyWith on LiveRides {
  /// Returns a callable class that can be used as follows: `instanceOfLiveRides.copyWith(...)` or like so:`instanceOfLiveRides.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveRidesCWProxy get copyWith => _$LiveRidesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveRides _$LiveRidesFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LiveRides', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['rides', 'onDutyDrivers']);
  final val = LiveRides(
    rides: $checkedConvert(
      'rides',
      (v) => (v as List<dynamic>)
          .map((e) => LiveRidesRidesInner.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    onDutyDrivers: $checkedConvert(
      'onDutyDrivers',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                LiveRidesOnDutyDriversInner.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$LiveRidesToJson(LiveRides instance) => <String, dynamic>{
  'rides': instance.rides.map((e) => e.toJson()).toList(),
  'onDutyDrivers': instance.onDutyDrivers.map((e) => e.toJson()).toList(),
};
