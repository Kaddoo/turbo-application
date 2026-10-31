//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_document.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDocument {
  /// Returns a new [VerificationDocument] instance.
  VerificationDocument({

    required  this.purpose,

    required  this.url,

    required  this.expiresAt,
  });

  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final VerificationDocumentPurposeEnum purpose;



      /// Signed URL, valid for a few minutes. Never cache or log it.
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDocument &&
      other.purpose == purpose &&
      other.url == url &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        purpose.hashCode +
        url.hashCode +
        expiresAt.hashCode;

  factory VerificationDocument.fromJson(Map<String, dynamic> json) => _$VerificationDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDocumentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VerificationDocumentPurposeEnum {
@JsonValue(r'ghana_card_front')
ghanaCardFront(r'ghana_card_front'),
@JsonValue(r'ghana_card_back')
ghanaCardBack(r'ghana_card_back'),
@JsonValue(r'student_id')
studentId(r'student_id'),
@JsonValue(r'selfie_with_card')
selfieWithCard(r'selfie_with_card');

const VerificationDocumentPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


