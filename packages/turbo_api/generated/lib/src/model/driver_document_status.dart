//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_document_kind.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_document_status.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDocumentStatus {
  /// Returns a new [DriverDocumentStatus] instance.
  DriverDocumentStatus({

    required  this.type,

     this.expiresOn,

     this.daysLeft,

    required  this.status,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final DriverDocumentKind type;



  @JsonKey(
    
    name: r'expiresOn',
    required: false,
    includeIfNull: false,
  )


  final DateTime? expiresOn;



      /// Whole days from today (Africa/Accra) to `expiresOn`, negative once expired. Null when the document has no expiry.
  @JsonKey(
    
    name: r'daysLeft',
    required: false,
    includeIfNull: false,
  )


  final int? daysLeft;



      /// `expiring` is under 30 days left; `expired` is past `expiresOn`. Computed by the server so the phone clock does not matter.
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final DriverDocumentStatusStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDocumentStatus &&
      other.type == type &&
      other.expiresOn == expiresOn &&
      other.daysLeft == daysLeft &&
      other.status == status;

    @override
    int get hashCode =>
        type.hashCode +
        (expiresOn == null ? 0 : expiresOn.hashCode) +
        (daysLeft == null ? 0 : daysLeft.hashCode) +
        status.hashCode;

  factory DriverDocumentStatus.fromJson(Map<String, dynamic> json) => _$DriverDocumentStatusFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDocumentStatusToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// `expiring` is under 30 days left; `expired` is past `expiresOn`. Computed by the server so the phone clock does not matter.
enum DriverDocumentStatusStatusEnum {
@JsonValue(r'valid')
valid(r'valid'),
@JsonValue(r'expiring')
expiring(r'expiring'),
@JsonValue(r'expired')
expired(r'expired');

const DriverDocumentStatusStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


