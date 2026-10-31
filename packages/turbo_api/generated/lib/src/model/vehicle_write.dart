//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_write.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VehicleWrite {
  /// Returns a new [VehicleWrite] instance.
  VehicleWrite({

    required  this.make,

    required  this.model,

    required  this.colour,

    required  this.plateNumber,

     this.seats,

     this.status,
  });

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



          // minimum: 1
          // maximum: 8
  @JsonKey(
    
    name: r'seats',
    required: false,
    includeIfNull: false,
  )


  final int? seats;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final VehicleWriteStatusEnum? status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VehicleWrite &&
      other.make == make &&
      other.model == model &&
      other.colour == colour &&
      other.plateNumber == plateNumber &&
      other.seats == seats &&
      other.status == status;

    @override
    int get hashCode =>
        make.hashCode +
        model.hashCode +
        colour.hashCode +
        plateNumber.hashCode +
        seats.hashCode +
        status.hashCode;

  factory VehicleWrite.fromJson(Map<String, dynamic> json) => _$VehicleWriteFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleWriteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VehicleWriteStatusEnum {
@JsonValue(r'active')
active(r'active'),
@JsonValue(r'maintenance')
maintenance(r'maintenance'),
@JsonValue(r'retired')
retired(r'retired');

const VehicleWriteStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


