//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms_acceptance.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TermsAcceptance {
  /// Returns a new [TermsAcceptance] instance.
  TermsAcceptance({

    required  this.termsVersion,

    required  this.privacyVersion,
  });

  @JsonKey(
    
    name: r'termsVersion',
    required: true,
    includeIfNull: false,
  )


  final String termsVersion;



  @JsonKey(
    
    name: r'privacyVersion',
    required: true,
    includeIfNull: false,
  )


  final String privacyVersion;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TermsAcceptance &&
      other.termsVersion == termsVersion &&
      other.privacyVersion == privacyVersion;

    @override
    int get hashCode =>
        termsVersion.hashCode +
        privacyVersion.hashCode;

  factory TermsAcceptance.fromJson(Map<String, dynamic> json) => _$TermsAcceptanceFromJson(json);

  Map<String, dynamic> toJson() => _$TermsAcceptanceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

