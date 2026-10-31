// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_public.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VehiclePublicCWProxy {
  VehiclePublic make(String make);

  VehiclePublic model(String model);

  VehiclePublic colour(String colour);

  VehiclePublic plateNumber(String plateNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehiclePublic(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehiclePublic(...).copyWith(id: 12, name: "My name")
  /// ````
  VehiclePublic call({
    String make,
    String model,
    String colour,
    String plateNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVehiclePublic.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVehiclePublic.copyWith.fieldName(...)`
class _$VehiclePublicCWProxyImpl implements _$VehiclePublicCWProxy {
  const _$VehiclePublicCWProxyImpl(this._value);

  final VehiclePublic _value;

  @override
  VehiclePublic make(String make) => this(make: make);

  @override
  VehiclePublic model(String model) => this(model: model);

  @override
  VehiclePublic colour(String colour) => this(colour: colour);

  @override
  VehiclePublic plateNumber(String plateNumber) =>
      this(plateNumber: plateNumber);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehiclePublic(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehiclePublic(...).copyWith(id: 12, name: "My name")
  /// ````
  VehiclePublic call({
    Object? make = const $CopyWithPlaceholder(),
    Object? model = const $CopyWithPlaceholder(),
    Object? colour = const $CopyWithPlaceholder(),
    Object? plateNumber = const $CopyWithPlaceholder(),
  }) {
    return VehiclePublic(
      make: make == const $CopyWithPlaceholder()
          ? _value.make
          // ignore: cast_nullable_to_non_nullable
          : make as String,
      model: model == const $CopyWithPlaceholder()
          ? _value.model
          // ignore: cast_nullable_to_non_nullable
          : model as String,
      colour: colour == const $CopyWithPlaceholder()
          ? _value.colour
          // ignore: cast_nullable_to_non_nullable
          : colour as String,
      plateNumber: plateNumber == const $CopyWithPlaceholder()
          ? _value.plateNumber
          // ignore: cast_nullable_to_non_nullable
          : plateNumber as String,
    );
  }
}

extension $VehiclePublicCopyWith on VehiclePublic {
  /// Returns a callable class that can be used as follows: `instanceOfVehiclePublic.copyWith(...)` or like so:`instanceOfVehiclePublic.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VehiclePublicCWProxy get copyWith => _$VehiclePublicCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclePublic _$VehiclePublicFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VehiclePublic', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['make', 'model', 'colour', 'plateNumber'],
      );
      final val = VehiclePublic(
        make: $checkedConvert('make', (v) => v as String),
        model: $checkedConvert('model', (v) => v as String),
        colour: $checkedConvert('colour', (v) => v as String),
        plateNumber: $checkedConvert('plateNumber', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$VehiclePublicToJson(VehiclePublic instance) =>
    <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'colour': instance.colour,
      'plateNumber': instance.plateNumber,
    };
