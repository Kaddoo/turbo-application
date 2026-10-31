//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_event.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RideEvent {
  /// Returns a new [RideEvent] instance.
  RideEvent({

    required  this.at,

    required  this.type,

    required  this.actor,

     this.detail,
  });

  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



      /// e.g. requested, assigned, driver_declined, reassigned, arrived, started, completed, cancelled, refunded
  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



      /// student | driver | system | staff:<id>
  @JsonKey(
    
    name: r'actor',
    required: true,
    includeIfNull: false,
  )


  final String actor;



  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false,
  )


  final String? detail;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RideEvent &&
      other.at == at &&
      other.type == type &&
      other.actor == actor &&
      other.detail == detail;

    @override
    int get hashCode =>
        at.hashCode +
        type.hashCode +
        actor.hashCode +
        (detail == null ? 0 : detail.hashCode);

  factory RideEvent.fromJson(Map<String, dynamic> json) => _$RideEventFromJson(json);

  Map<String, dynamic> toJson() => _$RideEventToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

