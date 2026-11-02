//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/place_match.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_match_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlaceMatchList {
  /// Returns a new [PlaceMatchList] instance.
  PlaceMatchList({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<PlaceMatch> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlaceMatchList &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory PlaceMatchList.fromJson(Map<String, dynamic> json) => _$PlaceMatchListFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceMatchListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

