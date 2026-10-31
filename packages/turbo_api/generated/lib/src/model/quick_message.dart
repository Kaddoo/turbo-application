//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/quick_message_code.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quick_message.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuickMessage {
  /// Returns a new [QuickMessage] instance.
  QuickMessage({

    required  this.from,

    required  this.code,

    required  this.sentAt,
  });

  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final QuickMessageFromEnum from;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final QuickMessageCode code;



  @JsonKey(
    
    name: r'sentAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime sentAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuickMessage &&
      other.from == from &&
      other.code == code &&
      other.sentAt == sentAt;

    @override
    int get hashCode =>
        from.hashCode +
        code.hashCode +
        sentAt.hashCode;

  factory QuickMessage.fromJson(Map<String, dynamic> json) => _$QuickMessageFromJson(json);

  Map<String, dynamic> toJson() => _$QuickMessageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum QuickMessageFromEnum {
@JsonValue(r'student')
student(r'student'),
@JsonValue(r'driver')
driver(r'driver');

const QuickMessageFromEnum(this.value);

final String value;

@override
String toString() => value;
}


