//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_summary_student.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationSummaryStudent {
  /// Returns a new [VerificationSummaryStudent] instance.
  VerificationSummaryStudent({

    required  this.id,

     this.fullName,

    required  this.phone,
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
    required: false,
    includeIfNull: false,
  )


  final String? fullName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationSummaryStudent &&
      other.id == id &&
      other.fullName == fullName &&
      other.phone == phone;

    @override
    int get hashCode =>
        id.hashCode +
        (fullName == null ? 0 : fullName.hashCode) +
        phone.hashCode;

  factory VerificationSummaryStudent.fromJson(Map<String, dynamic> json) => _$VerificationSummaryStudentFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationSummaryStudentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

