//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_complete_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCompleteRequest {
  /// Returns a new [AdminCompleteRequest] instance.
  AdminCompleteRequest({

    required  this.reasonCode,

    required  this.note,

     this.completionPoint,
  });

  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final AdminCompleteRequestReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;



      /// Where the trip ended, if known.
  @JsonKey(
    
    name: r'completionPoint',
    required: false,
    includeIfNull: false,
  )


  final GeoPoint? completionPoint;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCompleteRequest &&
      other.reasonCode == reasonCode &&
      other.note == note &&
      other.completionPoint == completionPoint;

    @override
    int get hashCode =>
        reasonCode.hashCode +
        note.hashCode +
        (completionPoint == null ? 0 : completionPoint.hashCode);

  factory AdminCompleteRequest.fromJson(Map<String, dynamic> json) => _$AdminCompleteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCompleteRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminCompleteRequestReasonCodeEnum {
@JsonValue(r'driver_unreachable')
driverUnreachable(r'driver_unreachable'),
@JsonValue(r'app_failure')
appFailure(r'app_failure'),
@JsonValue(r'driver_forgot')
driverForgot(r'driver_forgot'),
@JsonValue(r'other')
other(r'other');

const AdminCompleteRequestReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


