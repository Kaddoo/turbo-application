//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_document_expiry.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDocumentExpiry {
  /// Returns a new [DriverDocumentExpiry] instance.
  DriverDocumentExpiry({

    required  this.driverId,

    required  this.driverName,

    required  this.documentType,

    required  this.expiresOn,

    required  this.daysLeft,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



  @JsonKey(
    
    name: r'driverName',
    required: true,
    includeIfNull: false,
  )


  final String driverName;



  @JsonKey(
    
    name: r'documentType',
    required: true,
    includeIfNull: false,
  )


  final String documentType;



  @JsonKey(
    
    name: r'expiresOn',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresOn;



  @JsonKey(
    
    name: r'daysLeft',
    required: true,
    includeIfNull: false,
  )


  final int daysLeft;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDocumentExpiry &&
      other.driverId == driverId &&
      other.driverName == driverName &&
      other.documentType == documentType &&
      other.expiresOn == expiresOn &&
      other.daysLeft == daysLeft;

    @override
    int get hashCode =>
        driverId.hashCode +
        driverName.hashCode +
        documentType.hashCode +
        expiresOn.hashCode +
        daysLeft.hashCode;

  factory DriverDocumentExpiry.fromJson(Map<String, dynamic> json) => _$DriverDocumentExpiryFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDocumentExpiryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

