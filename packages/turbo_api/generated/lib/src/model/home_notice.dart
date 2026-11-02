//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_notice.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HomeNotice {
  /// Returns a new [HomeNotice] instance.
  HomeNotice({

    required  this.id,

    required  this.message,

    required  this.severity,
  });

      /// Changes when the message or its severity changes, so an app can remember that a student closed this one.
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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


  final HomeNoticeSeverityEnum severity;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HomeNotice &&
      other.id == id &&
      other.message == message &&
      other.severity == severity;

    @override
    int get hashCode =>
        id.hashCode +
        message.hashCode +
        severity.hashCode;

  factory HomeNotice.fromJson(Map<String, dynamic> json) => _$HomeNoticeFromJson(json);

  Map<String, dynamic> toJson() => _$HomeNoticeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HomeNoticeSeverityEnum {
@JsonValue(r'info')
info(r'info'),
@JsonValue(r'warning')
warning(r'warning'),
@JsonValue(r'critical')
critical(r'critical');

const HomeNoticeSeverityEnum(this.value);

final String value;

@override
String toString() => value;
}


