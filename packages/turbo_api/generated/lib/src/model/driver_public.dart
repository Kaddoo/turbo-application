//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_public.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverPublic {
  /// Returns a new [DriverPublic] instance.
  DriverPublic({

    required  this.id,

    required  this.firstName,

     this.photoUrl,

     this.averageRating,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'firstName',
    required: true,
    includeIfNull: false,
  )


  final String firstName;



  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'averageRating',
    required: false,
    includeIfNull: false,
  )


  final num? averageRating;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverPublic &&
      other.id == id &&
      other.firstName == firstName &&
      other.photoUrl == photoUrl &&
      other.averageRating == averageRating;

    @override
    int get hashCode =>
        id.hashCode +
        firstName.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        (averageRating == null ? 0 : averageRating.hashCode);

  factory DriverPublic.fromJson(Map<String, dynamic> json) => _$DriverPublicFromJson(json);

  Map<String, dynamic> toJson() => _$DriverPublicToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

