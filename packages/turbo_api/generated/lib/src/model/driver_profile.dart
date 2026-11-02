//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_document_status.dart';
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:turbo_api_generated/src/model/vehicle.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_profile.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverProfile {
  /// Returns a new [DriverProfile] instance.
  DriverProfile({

    required  this.id,

    required  this.fullName,

    required  this.phone,

     this.photoUrl,

    required  this.status,

    required  this.dutyStatus,

     this.vehicle,

     this.currentRideId,

     this.documents,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AccountStatus status;



  @JsonKey(
    
    name: r'dutyStatus',
    required: true,
    includeIfNull: false,
  )


  final DriverProfileDutyStatusEnum dutyStatus;



  @JsonKey(
    
    name: r'vehicle',
    required: false,
    includeIfNull: false,
  )


  final Vehicle? vehicle;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'currentRideId',
    required: false,
    includeIfNull: false,
  )


  final String? currentRideId;



      /// The documents that decide whether the driver may go on duty, one per type (the one that expires last). A type with no document uploaded is left out. The driver never needs the file, so no upload id or URL is sent.
  @JsonKey(
    
    name: r'documents',
    required: false,
    includeIfNull: false,
  )


  final List<DriverDocumentStatus>? documents;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverProfile &&
      other.id == id &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.photoUrl == photoUrl &&
      other.status == status &&
      other.dutyStatus == dutyStatus &&
      other.vehicle == vehicle &&
      other.currentRideId == currentRideId &&
      other.documents == documents;

    @override
    int get hashCode =>
        id.hashCode +
        fullName.hashCode +
        phone.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        status.hashCode +
        dutyStatus.hashCode +
        (vehicle == null ? 0 : vehicle.hashCode) +
        (currentRideId == null ? 0 : currentRideId.hashCode) +
        documents.hashCode;

  factory DriverProfile.fromJson(Map<String, dynamic> json) => _$DriverProfileFromJson(json);

  Map<String, dynamic> toJson() => _$DriverProfileToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DriverProfileDutyStatusEnum {
@JsonValue(r'off_duty')
offDuty(r'off_duty'),
@JsonValue(r'on_duty')
onDuty(r'on_duty');

const DriverProfileDutyStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


