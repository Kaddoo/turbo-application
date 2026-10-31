//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AnnouncementCreate {
  /// Returns a new [AnnouncementCreate] instance.
  AnnouncementCreate({

    required  this.audience,

    required  this.title,

    required  this.body,
  });

  @JsonKey(
    
    name: r'audience',
    required: true,
    includeIfNull: false,
  )


  final AnnouncementCreateAudienceEnum audience;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is AnnouncementCreate &&
      other.audience == audience &&
      other.title == title &&
      other.body == body;

    @override
    int get hashCode =>
        audience.hashCode +
        title.hashCode +
        body.hashCode;

  factory AnnouncementCreate.fromJson(Map<String, dynamic> json) => _$AnnouncementCreateFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AnnouncementCreateAudienceEnum {
@JsonValue(r'students')
students(r'students'),
@JsonValue(r'drivers')
drivers(r'drivers'),
@JsonValue(r'all')
all(r'all');

const AnnouncementCreateAudienceEnum(this.value);

final String value;

@override
String toString() => value;
}


