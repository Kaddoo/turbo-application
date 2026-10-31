//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/saved_place.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_place_collection.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SavedPlaceCollection {
  /// Returns a new [SavedPlaceCollection] instance.
  SavedPlaceCollection({

    required  this.data,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<SavedPlace> data;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SavedPlaceCollection &&
      other.data == data;

    @override
    int get hashCode =>
        data.hashCode;

  factory SavedPlaceCollection.fromJson(Map<String, dynamic> json) => _$SavedPlaceCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$SavedPlaceCollectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

