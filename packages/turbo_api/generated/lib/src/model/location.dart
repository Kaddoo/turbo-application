//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Location {
  /// Returns a new [Location] instance.
  Location({

    required  this.point,

     this.label,

     this.pickupPointId,

     this.landmark,
  });

  @JsonKey(
    
    name: r'point',
    required: true,
    includeIfNull: false,
  )


  final GeoPoint point;



      /// Human readable place name shown in the UI.
  @JsonKey(
    
    name: r'label',
    required: false,
    includeIfNull: false,
  )


  final String? label;



      /// Set when the student chose an official campus pickup point.
  @JsonKey(
    
    name: r'pickupPointId',
    required: false,
    includeIfNull: false,
  )


  final String? pickupPointId;



      /// Where exactly to meet, for example \"by the main gate\". Shown to the driver.
  @JsonKey(
    
    name: r'landmark',
    required: false,
    includeIfNull: false,
  )


  final String? landmark;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Location &&
      other.point == point &&
      other.label == label &&
      other.pickupPointId == pickupPointId &&
      other.landmark == landmark;

    @override
    int get hashCode =>
        point.hashCode +
        label.hashCode +
        (pickupPointId == null ? 0 : pickupPointId.hashCode) +
        landmark.hashCode;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

