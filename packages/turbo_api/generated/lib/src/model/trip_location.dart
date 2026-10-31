//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_location.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TripLocation {
  /// Returns a new [TripLocation] instance.
  TripLocation({

     this.location,
  });

  @JsonKey(
    
    name: r'location',
    required: false,
    includeIfNull: false,
  )


  final GeoPoint? location;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TripLocation &&
      other.location == location;

    @override
    int get hashCode =>
        location.hashCode;

  factory TripLocation.fromJson(Map<String, dynamic> json) => _$TripLocationFromJson(json);

  Map<String, dynamic> toJson() => _$TripLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

