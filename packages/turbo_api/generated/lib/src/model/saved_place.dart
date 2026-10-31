//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_place.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedPlace {
  /// Returns a new [SavedPlace] instance.
  SavedPlace({

    required  this.id,

    required  this.label,

    required  this.location,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final Location location;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SavedPlace &&
      other.id == id &&
      other.label == label &&
      other.location == location;

    @override
    int get hashCode =>
        id.hashCode +
        label.hashCode +
        location.hashCode;

  factory SavedPlace.fromJson(Map<String, dynamic> json) => _$SavedPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$SavedPlaceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

