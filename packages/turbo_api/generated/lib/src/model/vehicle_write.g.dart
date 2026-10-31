// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_write.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VehicleWriteCWProxy {
  VehicleWrite make(String make);

  VehicleWrite model(String model);

  VehicleWrite colour(String colour);

  VehicleWrite plateNumber(String plateNumber);

  VehicleWrite seats(int? seats);

  VehicleWrite status(VehicleWriteStatusEnum? status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehicleWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehicleWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  VehicleWrite call({
    String make,
    String model,
    String colour,
    String plateNumber,
    int? seats,
    VehicleWriteStatusEnum? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVehicleWrite.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVehicleWrite.copyWith.fieldName(...)`
class _$VehicleWriteCWProxyImpl implements _$VehicleWriteCWProxy {
  const _$VehicleWriteCWProxyImpl(this._value);

  final VehicleWrite _value;

  @override
  VehicleWrite make(String make) => this(make: make);

  @override
  VehicleWrite model(String model) => this(model: model);

  @override
  VehicleWrite colour(String colour) => this(colour: colour);

  @override
  VehicleWrite plateNumber(String plateNumber) =>
      this(plateNumber: plateNumber);

  @override
  VehicleWrite seats(int? seats) => this(seats: seats);

  @override
  VehicleWrite status(VehicleWriteStatusEnum? status) => this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VehicleWrite(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VehicleWrite(...).copyWith(id: 12, name: "My name")
  /// ````
  VehicleWrite call({
    Object? make = const $CopyWithPlaceholder(),
    Object? model = const $CopyWithPlaceholder(),
    Object? colour = const $CopyWithPlaceholder(),
    Object? plateNumber = const $CopyWithPlaceholder(),
    Object? seats = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return VehicleWrite(
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
          : status as VehicleWriteStatusEnum?,
    );
  }
}

extension $VehicleWriteCopyWith on VehicleWrite {
  /// Returns a callable class that can be used as follows: `instanceOfVehicleWrite.copyWith(...)` or like so:`instanceOfVehicleWrite.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VehicleWriteCWProxy get copyWith => _$VehicleWriteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleWrite _$VehicleWriteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VehicleWrite', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['make', 'model', 'colour', 'plateNumber'],
      );
      final val = VehicleWrite(
        make: $checkedConvert('make', (v) => v as String),
        model: $checkedConvert('model', (v) => v as String),
        colour: $checkedConvert('colour', (v) => v as String),
        plateNumber: $checkedConvert('plateNumber', (v) => v as String),
        seats: $checkedConvert('seats', (v) => (v as num?)?.toInt()),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$VehicleWriteStatusEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VehicleWriteToJson(VehicleWrite instance) =>
    <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'colour': instance.colour,
      'plateNumber': instance.plateNumber,
      'seats': ?instance.seats,
      'status': ?_$VehicleWriteStatusEnumEnumMap[instance.status],
    };

const _$VehicleWriteStatusEnumEnumMap = {
  VehicleWriteStatusEnum.active: 'active',
  VehicleWriteStatusEnum.maintenance: 'maintenance',
  VehicleWriteStatusEnum.retired: 'retired',
};
