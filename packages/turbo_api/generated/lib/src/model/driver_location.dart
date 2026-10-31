//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_location.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverLocation {
  /// Returns a new [DriverLocation] instance.
  DriverLocation({

    required  this.point,

     this.headingDegrees,

     this.speedMps,

    required  this.recordedAt,
  });

  @JsonKey(
    
    name: r'point',
    required: true,
    includeIfNull: false,
  )


  final GeoPoint point;



          // minimum: 0
          // maximum: 360
  @JsonKey(
    
    name: r'headingDegrees',
    required: false,
    includeIfNull: false,
  )


  final num? headingDegrees;



          // minimum: 0
  @JsonKey(
    
    name: r'speedMps',
    required: false,
    includeIfNull: false,
  )


  final num? speedMps;



  @JsonKey(
    
    name: r'recordedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime recordedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverLocation &&
      other.point == point &&
      other.headingDegrees == headingDegrees &&
      other.speedMps == speedMps &&
      other.recordedAt == recordedAt;

    @override
    int get hashCode =>
        point.hashCode +
        (headingDegrees == null ? 0 : headingDegrees.hashCode) +
        (speedMps == null ? 0 : speedMps.hashCode) +
        recordedAt.hashCode;

  factory DriverLocation.fromJson(Map<String, dynamic> json) => _$DriverLocationFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

