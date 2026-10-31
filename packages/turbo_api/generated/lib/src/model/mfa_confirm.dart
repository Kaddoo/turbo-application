//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mfa_confirm.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MfaConfirm {
  /// Returns a new [MfaConfirm] instance.
  MfaConfirm({

    required  this.enrollmentToken,

    required  this.totpCode,
  });

  @JsonKey(
    
    name: r'enrollmentToken',
    required: true,
    includeIfNull: false,
  )


  final String enrollmentToken;



  @JsonKey(
    
    name: r'totpCode',
    required: true,
    includeIfNull: false,
  )


  final String totpCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MfaConfirm &&
      other.enrollmentToken == enrollmentToken &&
      other.totpCode == totpCode;

    @override
    int get hashCode =>
        enrollmentToken.hashCode +
        totpCode.hashCode;

  factory MfaConfirm.fromJson(Map<String, dynamic> json) => _$MfaConfirmFromJson(json);

  Map<String, dynamic> toJson() => _$MfaConfirmToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

