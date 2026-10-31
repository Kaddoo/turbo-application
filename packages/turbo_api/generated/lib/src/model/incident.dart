//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Incident {
  /// Returns a new [Incident] instance.
  Incident({

    required  this.id,

    required  this.type,

    required  this.status,

     this.rideId,

     this.location,

     this.note,

    required  this.createdAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final IncidentTypeEnum type;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final IncidentStatusEnum status;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: false,
    includeIfNull: false,
  )


  final String? rideId;



  @JsonKey(
    
    name: r'location',
    required: false,
    includeIfNull: false,
  )


  final GeoPoint? location;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Incident &&
      other.id == id &&
      other.type == type &&
      other.status == status &&
      other.rideId == rideId &&
      other.location == location &&
      other.note == note &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        status.hashCode +
        (rideId == null ? 0 : rideId.hashCode) +
        (location == null ? 0 : location.hashCode) +
        (note == null ? 0 : note.hashCode) +
        createdAt.hashCode;

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum IncidentTypeEnum {
@JsonValue(r'sos')
sos(r'sos'),
@JsonValue(r'safety_report')
safetyReport(r'safety_report');

const IncidentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum IncidentStatusEnum {
@JsonValue(r'open')
open(r'open'),
@JsonValue(r'acknowledged')
acknowledged(r'acknowledged'),
@JsonValue(r'resolved')
resolved(r'resolved');

const IncidentStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


