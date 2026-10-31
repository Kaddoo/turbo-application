//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Announcement {
  /// Returns a new [Announcement] instance.
  Announcement({

    required  this.id,

    required  this.audience,

    required  this.title,

    required  this.body,

    required  this.sentBy,

     this.recipientCount,

    required  this.createdAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'audience',
    required: true,
    includeIfNull: false,
  )


  final String audience;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'sentBy',
    required: true,
    includeIfNull: false,
  )


  final String sentBy;



  @JsonKey(
    
    name: r'recipientCount',
    required: false,
    includeIfNull: false,
  )


  final int? recipientCount;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Announcement &&
      other.id == id &&
      other.audience == audience &&
      other.title == title &&
      other.body == body &&
      other.sentBy == sentBy &&
      other.recipientCount == recipientCount &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        audience.hashCode +
        title.hashCode +
        body.hashCode +
        sentBy.hashCode +
        recipientCount.hashCode +
        createdAt.hashCode;

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

