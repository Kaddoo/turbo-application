//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartRequest {
  /// Returns a new [StartRequest] instance.
  StartRequest({

    required  this.pin,
  });

  @JsonKey(
    
    name: r'pin',
    required: true,
    includeIfNull: false,
  )


  final String pin;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartRequest &&
      other.pin == pin;

    @override
    int get hashCode =>
        pin.hashCode;

  factory StartRequest.fromJson(Map<String, dynamic> json) => _$StartRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StartRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

