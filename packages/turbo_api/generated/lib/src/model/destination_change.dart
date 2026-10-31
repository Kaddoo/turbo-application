//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'destination_change.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DestinationChange {
  /// Returns a new [DestinationChange] instance.
  DestinationChange({

    required  this.dropoff,
  });

  @JsonKey(
    
    name: r'dropoff',
    required: true,
    includeIfNull: false,
  )


  final Location dropoff;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DestinationChange &&
      other.dropoff == dropoff;

    @override
    int get hashCode =>
        dropoff.hashCode;

  factory DestinationChange.fromJson(Map<String, dynamic> json) => _$DestinationChangeFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationChangeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

