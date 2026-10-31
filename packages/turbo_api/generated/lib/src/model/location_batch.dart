//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_location_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_batch.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationBatch {
  /// Returns a new [LocationBatch] instance.
  LocationBatch({

    required  this.points,
  });

  @JsonKey(
    
    name: r'points',
    required: true,
    includeIfNull: false,
  )


  final List<DriverLocationPoint> points;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LocationBatch &&
      other.points == points;

    @override
    int get hashCode =>
        points.hashCode;

  factory LocationBatch.fromJson(Map<String, dynamic> json) => _$LocationBatchFromJson(json);

  Map<String, dynamic> toJson() => _$LocationBatchToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

