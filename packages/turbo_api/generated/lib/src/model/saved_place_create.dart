//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_place_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedPlaceCreate {
  /// Returns a new [SavedPlaceCreate] instance.
  SavedPlaceCreate({

    required  this.label,

    required  this.location,
  });

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
    bool operator ==(Object other) => identical(this, other) || other is SavedPlaceCreate &&
      other.label == label &&
      other.location == location;

    @override
    int get hashCode =>
        label.hashCode +
        location.hashCode;

  factory SavedPlaceCreate.fromJson(Map<String, dynamic> json) => _$SavedPlaceCreateFromJson(json);

  Map<String, dynamic> toJson() => _$SavedPlaceCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

