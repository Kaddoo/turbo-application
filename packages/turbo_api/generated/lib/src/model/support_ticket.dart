//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/support_message.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_ticket.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SupportTicket {
  /// Returns a new [SupportTicket] instance.
  SupportTicket({

    required  this.id,

    required  this.category,

    required  this.status,

    required  this.subject,

     this.rideId,

     this.assignedToStaffId,

    required  this.createdAt,

    required  this.updatedAt,

     this.messages,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final String category;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final SupportTicketStatusEnum status;



  @JsonKey(
    
    name: r'subject',
    required: true,
    includeIfNull: false,
  )


  final String subject;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: false,
    includeIfNull: false,
  )


  final String? rideId;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'assignedToStaffId',
    required: false,
    includeIfNull: false,
  )


  final String? assignedToStaffId;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;



      /// Included on the detail endpoint only.
  @JsonKey(
    
    name: r'messages',
    required: false,
    includeIfNull: false,
  )


  final List<SupportMessage>? messages;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SupportTicket &&
      other.id == id &&
      other.category == category &&
      other.status == status &&
      other.subject == subject &&
      other.rideId == rideId &&
      other.assignedToStaffId == assignedToStaffId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.messages == messages;

    @override
    int get hashCode =>
        id.hashCode +
        category.hashCode +
        status.hashCode +
        subject.hashCode +
        (rideId == null ? 0 : rideId.hashCode) +
        (assignedToStaffId == null ? 0 : assignedToStaffId.hashCode) +
        createdAt.hashCode +
        updatedAt.hashCode +
        messages.hashCode;

  factory SupportTicket.fromJson(Map<String, dynamic> json) => _$SupportTicketFromJson(json);

  Map<String, dynamic> toJson() => _$SupportTicketToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SupportTicketStatusEnum {
@JsonValue(r'open')
open(r'open'),
@JsonValue(r'in_progress')
inProgress(r'in_progress'),
@JsonValue(r'waiting_on_user')
waitingOnUser(r'waiting_on_user'),
@JsonValue(r'resolved')
resolved(r'resolved'),
@JsonValue(r'closed')
closed(r'closed');

const SupportTicketStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


