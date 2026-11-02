//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_notice_input.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HomeNoticeInput {
  /// Returns a new [HomeNoticeInput] instance.
  HomeNoticeInput({

    required  this.message,

    required  this.severity,
  });

  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



  @JsonKey(
    
    name: r'severity',
    required: true,
    includeIfNull: false,
  )


  final HomeNoticeInputSeverityEnum severity;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HomeNoticeInput &&
      other.message == message &&
      other.severity == severity;

    @override
    int get hashCode =>
        message.hashCode +
        severity.hashCode;

  factory HomeNoticeInput.fromJson(Map<String, dynamic> json) => _$HomeNoticeInputFromJson(json);

  Map<String, dynamic> toJson() => _$HomeNoticeInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HomeNoticeInputSeverityEnum {
@JsonValue(r'info')
info(r'info'),
@JsonValue(r'warning')
warning(r'warning'),
@JsonValue(r'critical')
critical(r'critical');

const HomeNoticeInputSeverityEnum(this.value);

final String value;

@override
String toString() => value;
}


