//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pickup_point_write.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PickupPointWrite {
  /// Returns a new [PickupPointWrite] instance.
  PickupPointWrite({

    required  this.name,

    required  this.point,

     this.isActive = true,
  });

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
    defaultValue: true,
    name: r'isActive',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PickupPointWrite &&
      other.name == name &&
      other.point == point &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        name.hashCode +
        point.hashCode +
        isActive.hashCode;

  factory PickupPointWrite.fromJson(Map<String, dynamic> json) => _$PickupPointWriteFromJson(json);

  Map<String, dynamic> toJson() => _$PickupPointWriteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

