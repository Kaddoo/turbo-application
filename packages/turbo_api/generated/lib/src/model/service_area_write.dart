//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_json_polygon.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_area_write.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceAreaWrite {
  /// Returns a new [ServiceAreaWrite] instance.
  ServiceAreaWrite({

    required  this.boundary,
  });

  @JsonKey(
    
    name: r'boundary',
    required: true,
    includeIfNull: false,
  )


  final GeoJsonPolygon boundary;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceAreaWrite &&
      other.boundary == boundary;

    @override
    int get hashCode =>
        boundary.hashCode;

  factory ServiceAreaWrite.fromJson(Map<String, dynamic> json) => _$ServiceAreaWriteFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAreaWriteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

