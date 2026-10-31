//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/fare_band.dart';
import 'package:turbo_api_generated/src/model/geo_json_polygon.dart';
import 'package:turbo_api_generated/src/model/operating_window.dart';
import 'package:turbo_api_generated/src/model/pickup_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_area.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceArea {
  /// Returns a new [ServiceArea] instance.
  ServiceArea({

    required  this.version,

    required  this.boundary,

    required  this.pickupPoints,

    required  this.maxTripDistanceMeters,

    required  this.fareBands,

     this.operatingHours,
  });

  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final int version;



  @JsonKey(
    
    name: r'boundary',
    required: true,
    includeIfNull: true,
  )


  final GeoJsonPolygon? boundary;



  @JsonKey(
    
    name: r'pickupPoints',
    required: true,
    includeIfNull: false,
  )


  final List<PickupPoint> pickupPoints;



  @JsonKey(
    
    name: r'maxTripDistanceMeters',
    required: true,
    includeIfNull: false,
  )


  final int maxTripDistanceMeters;



  @JsonKey(
    
    name: r'fareBands',
    required: true,
    includeIfNull: false,
  )


  final List<FareBand> fareBands;



  @JsonKey(
    
    name: r'operatingHours',
    required: false,
    includeIfNull: false,
  )


  final List<OperatingWindow>? operatingHours;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceArea &&
      other.version == version &&
      other.boundary == boundary &&
      other.pickupPoints == pickupPoints &&
      other.maxTripDistanceMeters == maxTripDistanceMeters &&
      other.fareBands == fareBands &&
      other.operatingHours == operatingHours;

    @override
    int get hashCode =>
        version.hashCode +
        (boundary == null ? 0 : boundary.hashCode) +
        pickupPoints.hashCode +
        maxTripDistanceMeters.hashCode +
        fareBands.hashCode +
        (operatingHours == null ? 0 : operatingHours.hashCode);

  factory ServiceArea.fromJson(Map<String, dynamic> json) => _$ServiceAreaFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAreaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

