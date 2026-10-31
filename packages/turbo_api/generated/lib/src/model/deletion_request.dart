//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deletion_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeletionRequest {
  /// Returns a new [DeletionRequest] instance.
  DeletionRequest({

    required  this.id,

    required  this.status,

    required  this.requestedAt,

     this.scheduledFor,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final DeletionRequestStatusEnum status;



  @JsonKey(
    
    name: r'requestedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime requestedAt;



  @JsonKey(
    
    name: r'scheduledFor',
    required: false,
    includeIfNull: false,
  )


  final DateTime? scheduledFor;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeletionRequest &&
      other.id == id &&
      other.status == status &&
      other.requestedAt == requestedAt &&
      other.scheduledFor == scheduledFor;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        requestedAt.hashCode +
        (scheduledFor == null ? 0 : scheduledFor.hashCode);

  factory DeletionRequest.fromJson(Map<String, dynamic> json) => _$DeletionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeletionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DeletionRequestStatusEnum {
@JsonValue(r'received')
received(r'received'),
@JsonValue(r'scheduled')
scheduled(r'scheduled'),
@JsonValue(r'completed')
completed(r'completed');

const DeletionRequestStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


