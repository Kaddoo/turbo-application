//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_document.dart';
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:turbo_api_generated/src/model/vehicle.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_detail.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDetail {
  /// Returns a new [DriverDetail] instance.
  DriverDetail({

    required  this.id,

    required  this.fullName,

    required  this.phone,

     this.email,

    required  this.status,

    required  this.dutyStatus,

     this.vehicle,

     this.currentRideId,

     this.lastLocation,

     this.documents,

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
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



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


  final DriverDetailDutyStatusEnum dutyStatus;



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



  @JsonKey(
    
    name: r'lastLocation',
    required: false,
    includeIfNull: false,
  )


  final DriverLocation? lastLocation;



  @JsonKey(
    
    name: r'documents',
    required: false,
    includeIfNull: false,
  )


  final List<DriverDocument>? documents;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDetail &&
      other.id == id &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.email == email &&
      other.status == status &&
      other.dutyStatus == dutyStatus &&
      other.vehicle == vehicle &&
      other.currentRideId == currentRideId &&
      other.lastLocation == lastLocation &&
      other.documents == documents &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        fullName.hashCode +
        phone.hashCode +
        (email == null ? 0 : email.hashCode) +
        status.hashCode +
        dutyStatus.hashCode +
        (vehicle == null ? 0 : vehicle.hashCode) +
        (currentRideId == null ? 0 : currentRideId.hashCode) +
        (lastLocation == null ? 0 : lastLocation.hashCode) +
        documents.hashCode +
        createdAt.hashCode;

  factory DriverDetail.fromJson(Map<String, dynamic> json) => _$DriverDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DriverDetailDutyStatusEnum {
@JsonValue(r'off_duty')
offDuty(r'off_duty'),
@JsonValue(r'on_duty')
onDuty(r'on_duty');

const DriverDetailDutyStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


