//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_cancel_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCancelRequest {
  /// Returns a new [AdminCancelRequest] instance.
  AdminCancelRequest({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCancelRequest &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory AdminCancelRequest.fromJson(Map<String, dynamic> json) => _$AdminCancelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCancelRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

