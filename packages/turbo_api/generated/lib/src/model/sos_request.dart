//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sos_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SosRequest {
  /// Returns a new [SosRequest] instance.
  SosRequest({

     this.rideId,

    required  this.location,

     this.note,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: false,
    includeIfNull: false,
  )


  final String? rideId;



  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: false,
  )


  final GeoPoint location;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SosRequest &&
      other.rideId == rideId &&
      other.location == location &&
      other.note == note;

    @override
    int get hashCode =>
        (rideId == null ? 0 : rideId.hashCode) +
        location.hashCode +
        note.hashCode;

  factory SosRequest.fromJson(Map<String, dynamic> json) => _$SosRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SosRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

