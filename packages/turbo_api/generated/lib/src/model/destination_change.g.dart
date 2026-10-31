// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_change.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DestinationChangeCWProxy {
  DestinationChange dropoff(Location dropoff);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DestinationChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DestinationChange(...).copyWith(id: 12, name: "My name")
  /// ````
  DestinationChange call({Location dropoff});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDestinationChange.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDestinationChange.copyWith.fieldName(...)`
class _$DestinationChangeCWProxyImpl implements _$DestinationChangeCWProxy {
  const _$DestinationChangeCWProxyImpl(this._value);

  final DestinationChange _value;

  @override
  DestinationChange dropoff(Location dropoff) => this(dropoff: dropoff);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DestinationChange(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DestinationChange(...).copyWith(id: 12, name: "My name")
  /// ````
  DestinationChange call({Object? dropoff = const $CopyWithPlaceholder()}) {
    return DestinationChange(
      dropoff: dropoff == const $CopyWithPlaceholder()
          ? _value.dropoff
          // ignore: cast_nullable_to_non_nullable
          : dropoff as Location,
    );
  }
}

extension $DestinationChangeCopyWith on DestinationChange {
  /// Returns a callable class that can be used as follows: `instanceOfDestinationChange.copyWith(...)` or like so:`instanceOfDestinationChange.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DestinationChangeCWProxy get copyWith =>
      _$DestinationChangeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DestinationChange _$DestinationChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DestinationChange', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['dropoff']);
      final val = DestinationChange(
        dropoff: $checkedConvert(
          'dropoff',
          (v) => Location.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DestinationChangeToJson(DestinationChange instance) =>
    <String, dynamic>{'dropoff': instance.dropoff.toJson()};
