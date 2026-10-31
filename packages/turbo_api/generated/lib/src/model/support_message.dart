//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_message.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SupportMessage {
  /// Returns a new [SupportMessage] instance.
  SupportMessage({

    required  this.id,

    required  this.author,

    required  this.body,

     this.internal,

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
    
    name: r'author',
    required: true,
    includeIfNull: false,
  )


  final SupportMessageAuthorEnum author;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// Internal notes are never returned to students or drivers.
  @JsonKey(
    
    name: r'internal',
    required: false,
    includeIfNull: false,
  )


  final bool? internal;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SupportMessage &&
      other.id == id &&
      other.author == author &&
      other.body == body &&
      other.internal == internal &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        author.hashCode +
        body.hashCode +
        internal.hashCode +
        createdAt.hashCode;

  factory SupportMessage.fromJson(Map<String, dynamic> json) => _$SupportMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SupportMessageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SupportMessageAuthorEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'staff')
staff(r'staff');

const SupportMessageAuthorEnum(this.value);

final String value;

@override
String toString() => value;
}


