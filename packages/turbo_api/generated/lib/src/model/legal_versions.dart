//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_versions.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalVersions {
  /// Returns a new [LegalVersions] instance.
  LegalVersions({

    required  this.termsVersion,

    required  this.privacyVersion,

    required  this.termsUrl,

    required  this.privacyUrl,

     this.locationNoticeUrl,
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



  @JsonKey(
    
    name: r'termsUrl',
    required: true,
    includeIfNull: false,
  )


  final String termsUrl;



  @JsonKey(
    
    name: r'privacyUrl',
    required: true,
    includeIfNull: false,
  )


  final String privacyUrl;



  @JsonKey(
    
    name: r'locationNoticeUrl',
    required: false,
    includeIfNull: false,
  )


  final String? locationNoticeUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalVersions &&
      other.termsVersion == termsVersion &&
      other.privacyVersion == privacyVersion &&
      other.termsUrl == termsUrl &&
      other.privacyUrl == privacyUrl &&
      other.locationNoticeUrl == locationNoticeUrl;

    @override
    int get hashCode =>
        termsVersion.hashCode +
        privacyVersion.hashCode +
        termsUrl.hashCode +
        privacyUrl.hashCode +
        locationNoticeUrl.hashCode;

  factory LegalVersions.fromJson(Map<String, dynamic> json) => _$LegalVersionsFromJson(json);

  Map<String, dynamic> toJson() => _$LegalVersionsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

