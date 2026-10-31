//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TicketUpdate {
  /// Returns a new [TicketUpdate] instance.
  TicketUpdate({

     this.status,

     this.assignedToStaffId,
  });

  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final TicketUpdateStatusEnum? status;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'assignedToStaffId',
    required: false,
    includeIfNull: false,
  )


  final String? assignedToStaffId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TicketUpdate &&
      other.status == status &&
      other.assignedToStaffId == assignedToStaffId;

    @override
    int get hashCode =>
        status.hashCode +
        (assignedToStaffId == null ? 0 : assignedToStaffId.hashCode);

  factory TicketUpdate.fromJson(Map<String, dynamic> json) => _$TicketUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$TicketUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TicketUpdateStatusEnum {
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

const TicketUpdateStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


