// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VehicleCWProxy {
  Vehicle id(String id);

  Vehicle make(String make);

  Vehicle model(String model);

  Vehicle colour(String colour);

  Vehicle plateNumber(String plateNumber);

  Vehicle seats(int? seats);

  Vehicle status(VehicleStatusEnum status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Vehicle(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Vehicle(...).copyWith(id: 12, name: "My name")
  /// ````
  Vehicle call({
    String id,
    String make,
    String model,
    String colour,
    String plateNumber,
    int? seats,
    VehicleStatusEnum status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVehicle.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVehicle.copyWith.fieldName(...)`
class _$VehicleCWProxyImpl implements _$VehicleCWProxy {
  const _$VehicleCWProxyImpl(this._value);

  final Vehicle _value;

  @override
  Vehicle id(String id) => this(id: id);

  @override
  Vehicle make(String make) => this(make: make);

  @override
  Vehicle model(String model) => this(model: model);

  @override
  Vehicle colour(String colour) => this(colour: colour);

  @override
  Vehicle plateNumber(String plateNumber) => this(plateNumber: plateNumber);

  @override
  Vehicle seats(int? seats) => this(seats: seats);

  @override
  Vehicle status(VehicleStatusEnum status) => this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Vehicle(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Vehicle(...).copyWith(id: 12, name: "My name")
  /// ````
  Vehicle call({
    Object? id = const $CopyWithPlaceholder(),
    Object? make = const $CopyWithPlaceholder(),
    Object? model = const $CopyWithPlaceholder(),
    Object? colour = const $CopyWithPlaceholder(),
    Object? plateNumber = const $CopyWithPlaceholder(),
    Object? seats = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return Vehicle(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      seats: seats == const $CopyWithPlaceholder()
          ? _value.seats
          // ignore: cast_nullable_to_non_nullable
          : seats as int?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VehicleStatusEnum,
    );
  }
}

extension $VehicleCopyWith on Vehicle {
  /// Returns a callable class that can be used as follows: `instanceOfVehicle.copyWith(...)` or like so:`instanceOfVehicle.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VehicleCWProxy get copyWith => _$VehicleCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Vehicle', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'make',
          'model',
          'colour',
          'plateNumber',
          'status',
        ],
      );
      final val = Vehicle(
        id: $checkedConvert('id', (v) => v as String),
        make: $checkedConvert('make', (v) => v as String),
        model: $checkedConvert('model', (v) => v as String),
        colour: $checkedConvert('colour', (v) => v as String),
        plateNumber: $checkedConvert('plateNumber', (v) => v as String),
        seats: $checkedConvert('seats', (v) => (v as num?)?.toInt()),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$VehicleStatusEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'make': instance.make,
  'model': instance.model,
  'colour': instance.colour,
  'plateNumber': instance.plateNumber,
  'seats': ?instance.seats,
  'status': _$VehicleStatusEnumEnumMap[instance.status]!,
};

const _$VehicleStatusEnumEnumMap = {
  VehicleStatusEnum.active: 'active',
  VehicleStatusEnum.maintenance: 'maintenance',
  VehicleStatusEnum.retired: 'retired',
};
