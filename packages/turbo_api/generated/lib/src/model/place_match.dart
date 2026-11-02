//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_match.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlaceMatch {
  /// Returns a new [PlaceMatch] instance.
  PlaceMatch({

    required  this.placeId,

    required  this.label,

     this.landmark,

    required  this.isPickupPoint,
  });

      /// Opaque. Pass to `GET /places/{placeId}`.
  @JsonKey(
    
    name: r'placeId',
    required: true,
    includeIfNull: false,
  )


  final String placeId;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'landmark',
    required: false,
    includeIfNull: false,
  )


  final String? landmark;



      /// True for an official campus pickup point.
  @JsonKey(
    
    name: r'isPickupPoint',
    required: true,
    includeIfNull: false,
  )


  final bool isPickupPoint;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlaceMatch &&
      other.placeId == placeId &&
      other.label == label &&
      other.landmark == landmark &&
      other.isPickupPoint == isPickupPoint;

    @override
    int get hashCode =>
        placeId.hashCode +
        label.hashCode +
        (landmark == null ? 0 : landmark.hashCode) +
        isPickupPoint.hashCode;

  factory PlaceMatch.fromJson(Map<String, dynamic> json) => _$PlaceMatchFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceMatchToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

