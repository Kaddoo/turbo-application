//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RatingCreate {
  /// Returns a new [RatingCreate] instance.
  RatingCreate({

    required  this.stars,

     this.tags,

     this.comment,
  });

          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final int stars;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final List<String>? tags;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RatingCreate &&
      other.stars == stars &&
      other.tags == tags &&
      other.comment == comment;

    @override
    int get hashCode =>
        stars.hashCode +
        tags.hashCode +
        comment.hashCode;

  factory RatingCreate.fromJson(Map<String, dynamic> json) => _$RatingCreateFromJson(json);

  Map<String, dynamic> toJson() => _$RatingCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

