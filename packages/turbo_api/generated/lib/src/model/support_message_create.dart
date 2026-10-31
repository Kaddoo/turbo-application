//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_message_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SupportMessageCreate {
  /// Returns a new [SupportMessageCreate] instance.
  SupportMessageCreate({

    required  this.body,

     this.internal = false,
  });

  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



  @JsonKey(
    defaultValue: false,
    name: r'internal',
    required: false,
    includeIfNull: false,
  )


  final bool? internal;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SupportMessageCreate &&
      other.body == body &&
      other.internal == internal;

    @override
    int get hashCode =>
        body.hashCode +
        internal.hashCode;

  factory SupportMessageCreate.fromJson(Map<String, dynamic> json) => _$SupportMessageCreateFromJson(json);

  Map<String, dynamic> toJson() => _$SupportMessageCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

