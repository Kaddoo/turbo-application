//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/quick_message_code.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quick_message_send.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuickMessageSend {
  /// Returns a new [QuickMessageSend] instance.
  QuickMessageSend({

    required  this.code,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final QuickMessageCode code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuickMessageSend &&
      other.code == code;

    @override
    int get hashCode =>
        code.hashCode;

  factory QuickMessageSend.fromJson(Map<String, dynamic> json) => _$QuickMessageSendFromJson(json);

  Map<String, dynamic> toJson() => _$QuickMessageSendToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

