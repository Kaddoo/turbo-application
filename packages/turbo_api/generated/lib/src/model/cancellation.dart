//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancellation.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Cancellation {
  /// Returns a new [Cancellation] instance.
  Cancellation({

    required  this.by,

    required  this.reasonCode,

     this.note,

    required  this.cancelledAt,
  });

  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final CancellationByEnum by;



  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final CancellationReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



  @JsonKey(
    
    name: r'cancelledAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime cancelledAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Cancellation &&
      other.by == by &&
      other.reasonCode == reasonCode &&
      other.note == note &&
      other.cancelledAt == cancelledAt;

    @override
    int get hashCode =>
        by.hashCode +
        reasonCode.hashCode +
        (note == null ? 0 : note.hashCode) +
        cancelledAt.hashCode;

  factory Cancellation.fromJson(Map<String, dynamic> json) => _$CancellationFromJson(json);

  Map<String, dynamic> toJson() => _$CancellationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CancellationByEnum {
@JsonValue(r'student')
student(r'student'),
@JsonValue(r'driver')
driver(r'driver'),
@JsonValue(r'system')
system(r'system'),
@JsonValue(r'admin')
admin(r'admin');

const CancellationByEnum(this.value);

final String value;

@override
String toString() => value;
}


enum CancellationReasonCodeEnum {
@JsonValue(r'student_changed_mind')
studentChangedMind(r'student_changed_mind'),
@JsonValue(r'driver_unavailable')
driverUnavailable(r'driver_unavailable'),
@JsonValue(r'vehicle_issue')
vehicleIssue(r'vehicle_issue'),
@JsonValue(r'no_driver_available')
noDriverAvailable(r'no_driver_available'),
@JsonValue(r'service_issue')
serviceIssue(r'service_issue'),
@JsonValue(r'admin_decision')
adminDecision(r'admin_decision'),
@JsonValue(r'other')
other(r'other'),
@JsonValue(r'rider_no_show')
riderNoShow(r'rider_no_show');

const CancellationReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


