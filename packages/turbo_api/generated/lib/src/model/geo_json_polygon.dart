//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_json_polygon.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GeoJsonPolygon {
  /// Returns a new [GeoJsonPolygon] instance.
  GeoJsonPolygon({

    required  this.type,

    required  this.coordinates,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final GeoJsonPolygonTypeEnum type;



      /// GeoJSON order: [lng, lat]. First ring is the outer boundary and must be closed.
  @JsonKey(
    
    name: r'coordinates',
    required: true,
    includeIfNull: false,
  )


  final List<List<List<num>>> coordinates;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GeoJsonPolygon &&
      other.type == type &&
      other.coordinates == coordinates;

    @override
    int get hashCode =>
        type.hashCode +
        coordinates.hashCode;

  factory GeoJsonPolygon.fromJson(Map<String, dynamic> json) => _$GeoJsonPolygonFromJson(json);

  Map<String, dynamic> toJson() => _$GeoJsonPolygonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GeoJsonPolygonTypeEnum {
@JsonValue(r'Polygon')
polygon(r'Polygon');

const GeoJsonPolygonTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


