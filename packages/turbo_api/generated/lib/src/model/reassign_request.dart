//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reassign_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReassignRequest {
  /// Returns a new [ReassignRequest] instance.
  ReassignRequest({

    required  this.driverId,

    required  this.reason,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReassignRequest &&
      other.driverId == driverId &&
      other.reason == reason;

    @override
    int get hashCode =>
        driverId.hashCode +
        reason.hashCode;

  factory ReassignRequest.fromJson(Map<String, dynamic> json) => _$ReassignRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReassignRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

