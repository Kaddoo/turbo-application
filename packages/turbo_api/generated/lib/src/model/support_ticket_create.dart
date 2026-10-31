//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_ticket_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SupportTicketCreate {
  /// Returns a new [SupportTicketCreate] instance.
  SupportTicketCreate({

    required  this.category,

     this.rideId,

    required  this.subject,

    required  this.message,

     this.uploadIds,
  });

  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final SupportTicketCreateCategoryEnum category;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: false,
    includeIfNull: false,
  )


  final String? rideId;



  @JsonKey(
    
    name: r'subject',
    required: true,
    includeIfNull: false,
  )


  final String subject;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



  @JsonKey(
    
    name: r'uploadIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? uploadIds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SupportTicketCreate &&
      other.category == category &&
      other.rideId == rideId &&
      other.subject == subject &&
      other.message == message &&
      other.uploadIds == uploadIds;

    @override
    int get hashCode =>
        category.hashCode +
        (rideId == null ? 0 : rideId.hashCode) +
        subject.hashCode +
        message.hashCode +
        uploadIds.hashCode;

  factory SupportTicketCreate.fromJson(Map<String, dynamic> json) => _$SupportTicketCreateFromJson(json);

  Map<String, dynamic> toJson() => _$SupportTicketCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SupportTicketCreateCategoryEnum {
@JsonValue(r'safety')
safety(r'safety'),
@JsonValue(r'driver_conduct')
driverConduct(r'driver_conduct'),
@JsonValue(r'vehicle')
vehicle(r'vehicle'),
@JsonValue(r'wrong_charge')
wrongCharge(r'wrong_charge'),
@JsonValue(r'payment_problem')
paymentProblem(r'payment_problem'),
@JsonValue(r'lost_item')
lostItem(r'lost_item'),
@JsonValue(r'account')
account(r'account'),
@JsonValue(r'other')
other(r'other'),
@JsonValue(r'phone_change')
phoneChange(r'phone_change'),
@JsonValue(r'data_request')
dataRequest(r'data_request');

const SupportTicketCreateCategoryEnum(this.value);

final String value;

@override
String toString() => value;
}


