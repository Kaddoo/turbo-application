//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_public.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VehiclePublic {
  /// Returns a new [VehiclePublic] instance.
  VehiclePublic({

    required  this.make,

    required  this.model,

    required  this.colour,

    required  this.plateNumber,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is VehiclePublic &&
      other.make == make &&
      other.model == model &&
      other.colour == colour &&
      other.plateNumber == plateNumber;

    @override
    int get hashCode =>
        make.hashCode +
        model.hashCode +
        colour.hashCode +
        plateNumber.hashCode;

  factory VehiclePublic.fromJson(Map<String, dynamic> json) => _$VehiclePublicFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclePublicToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

