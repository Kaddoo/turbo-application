//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Vehicle {
  /// Returns a new [Vehicle] instance.
  Vehicle({

    required  this.id,

    required  this.make,

    required  this.model,

    required  this.colour,

    required  this.plateNumber,

     this.seats,

    required  this.status,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'make',
    required: true,
    includeIfNull: false,
  )


  final String make;



  @JsonKey(
    
    name: r'model',
    required: true,
    includeIfNull: false,
  )


  final String model;



  @JsonKey(
    
    name: r'colour',
    required: true,
    includeIfNull: false,
  )


  final String colour;



  @JsonKey(
    
    name: r'plateNumber',
    required: true,
    includeIfNull: false,
  )


  final String plateNumber;



  @JsonKey(
    
    name: r'seats',
    required: false,
    includeIfNull: false,
  )


  final int? seats;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final VehicleStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Vehicle &&
      other.id == id &&
      other.make == make &&
      other.model == model &&
      other.colour == colour &&
      other.plateNumber == plateNumber &&
      other.seats == seats &&
      other.status == status;

    @override
    int get hashCode =>
        id.hashCode +
        make.hashCode +
        model.hashCode +
        colour.hashCode +
        plateNumber.hashCode +
        seats.hashCode +
        status.hashCode;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VehicleStatusEnum {
@JsonValue(r'active')
active(r'active'),
@JsonValue(r'maintenance')
maintenance(r'maintenance'),
@JsonValue(r'retired')
retired(r'retired');

const VehicleStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


