//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_document_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDocumentCreate {
  /// Returns a new [DriverDocumentCreate] instance.
  DriverDocumentCreate({

    required  this.type,

    required  this.uploadId,

     this.expiresOn,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final DriverDocumentCreateTypeEnum type;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'uploadId',
    required: true,
    includeIfNull: false,
  )


  final String uploadId;



  @JsonKey(
    
    name: r'expiresOn',
    required: false,
    includeIfNull: false,
  )


  final DateTime? expiresOn;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDocumentCreate &&
      other.type == type &&
      other.uploadId == uploadId &&
      other.expiresOn == expiresOn;

    @override
    int get hashCode =>
        type.hashCode +
        uploadId.hashCode +
        expiresOn.hashCode;

  factory DriverDocumentCreate.fromJson(Map<String, dynamic> json) => _$DriverDocumentCreateFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDocumentCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DriverDocumentCreateTypeEnum {
@JsonValue(r'drivers_licence')
driversLicence(r'drivers_licence'),
@JsonValue(r'ghana_card')
ghanaCard(r'ghana_card'),
@JsonValue(r'vehicle_registration')
vehicleRegistration(r'vehicle_registration'),
@JsonValue(r'insurance')
insurance(r'insurance'),
@JsonValue(r'roadworthy')
roadworthy(r'roadworthy'),
@JsonValue(r'other')
other(r'other');

const DriverDocumentCreateTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


