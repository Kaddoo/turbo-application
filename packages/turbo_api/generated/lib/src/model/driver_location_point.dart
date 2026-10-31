//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_location_point.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverLocationPoint {
  /// Returns a new [DriverLocationPoint] instance.
  DriverLocationPoint({

    required  this.point,

    required  this.recordedAt,

     this.accuracyMeters,

     this.headingDegrees,

     this.speedMps,
  });

  @JsonKey(
    
    name: r'point',
    required: true,
    includeIfNull: false,
  )


  final GeoPoint point;



  @JsonKey(
    
    name: r'recordedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime recordedAt;



  @JsonKey(
    
    name: r'accuracyMeters',
    required: false,
    includeIfNull: false,
  )


  final num? accuracyMeters;



  @JsonKey(
    
    name: r'headingDegrees',
    required: false,
    includeIfNull: false,
  )


  final num? headingDegrees;



  @JsonKey(
    
    name: r'speedMps',
    required: false,
    includeIfNull: false,
  )


  final num? speedMps;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverLocationPoint &&
      other.point == point &&
      other.recordedAt == recordedAt &&
      other.accuracyMeters == accuracyMeters &&
      other.headingDegrees == headingDegrees &&
      other.speedMps == speedMps;

    @override
    int get hashCode =>
        point.hashCode +
        recordedAt.hashCode +
        (accuracyMeters == null ? 0 : accuracyMeters.hashCode) +
        (headingDegrees == null ? 0 : headingDegrees.hashCode) +
        (speedMps == null ? 0 : speedMps.hashCode);

  factory DriverLocationPoint.fromJson(Map<String, dynamic> json) => _$DriverLocationPointFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLocationPointToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

