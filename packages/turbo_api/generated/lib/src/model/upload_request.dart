//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadRequest {
  /// Returns a new [UploadRequest] instance.
  UploadRequest({

    required  this.purpose,

    required  this.contentType,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final UploadRequestPurposeEnum purpose;



      /// text/csv is only accepted for purpose provider_statement (reconciliation).
  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final UploadRequestContentTypeEnum contentType;



          // minimum: 1
          // maximum: 10485760
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final int sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadRequest &&
      other.purpose == purpose &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        purpose.hashCode +
        contentType.hashCode +
        sizeBytes.hashCode;

  factory UploadRequest.fromJson(Map<String, dynamic> json) => _$UploadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UploadRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UploadRequestPurposeEnum {
@JsonValue(r'ghana_card_front')
ghanaCardFront(r'ghana_card_front'),
@JsonValue(r'ghana_card_back')
ghanaCardBack(r'ghana_card_back'),
@JsonValue(r'student_id')
studentId(r'student_id'),
@JsonValue(r'driver_document')
driverDocument(r'driver_document'),
@JsonValue(r'vehicle_document')
vehicleDocument(r'vehicle_document'),
@JsonValue(r'support_attachment')
supportAttachment(r'support_attachment'),
@JsonValue(r'selfie_with_card')
selfieWithCard(r'selfie_with_card'),
@JsonValue(r'provider_statement')
providerStatement(r'provider_statement');

const UploadRequestPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


/// text/csv is only accepted for purpose provider_statement (reconciliation).
enum UploadRequestContentTypeEnum {
@JsonValue(r'image/jpeg')
imageSlashJpeg(r'image/jpeg'),
@JsonValue(r'image/png')
imageSlashPng(r'image/png'),
@JsonValue(r'application/pdf')
applicationSlashPdf(r'application/pdf'),
@JsonValue(r'text/csv')
textSlashCsv(r'text/csv');

const UploadRequestContentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


