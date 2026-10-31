//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pickup_point.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PickupPoint {
  /// Returns a new [PickupPoint] instance.
  PickupPoint({

    required  this.id,

    required  this.name,

    required  this.point,

    required  this.isActive,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'point',
    required: true,
    includeIfNull: false,
  )


  final GeoPoint point;



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PickupPoint &&
      other.id == id &&
      other.name == name &&
      other.point == point &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        point.hashCode +
        isActive.hashCode;

  factory PickupPoint.fromJson(Map<String, dynamic> json) => _$PickupPointFromJson(json);

  Map<String, dynamic> toJson() => _$PickupPointToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

