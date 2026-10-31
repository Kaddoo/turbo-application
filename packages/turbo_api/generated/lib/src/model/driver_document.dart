//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_document.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDocument {
  /// Returns a new [DriverDocument] instance.
  DriverDocument({

    required  this.id,

    required  this.type,

     this.expiresOn,

    required  this.uploadId,
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


  final DriverDocumentTypeEnum type;



  @JsonKey(
    
    name: r'expiresOn',
    required: false,
    includeIfNull: false,
  )


  final DateTime? expiresOn;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'uploadId',
    required: true,
    includeIfNull: false,
  )


  final String uploadId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDocument &&
      other.id == id &&
      other.type == type &&
      other.expiresOn == expiresOn &&
      other.uploadId == uploadId;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        (expiresOn == null ? 0 : expiresOn.hashCode) +
        uploadId.hashCode;

  factory DriverDocument.fromJson(Map<String, dynamic> json) => _$DriverDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDocumentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DriverDocumentTypeEnum {
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

const DriverDocumentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


