//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StudentUpdate {
  /// Returns a new [StudentUpdate] instance.
  StudentUpdate({

     this.fullName,

     this.email,
  });

  @JsonKey(
    
    name: r'fullName',
    required: false,
    includeIfNull: false,
  )


  final String? fullName;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StudentUpdate &&
      other.fullName == fullName &&
      other.email == email;

    @override
    int get hashCode =>
        fullName.hashCode +
        email.hashCode;

  factory StudentUpdate.fromJson(Map<String, dynamic> json) => _$StudentUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$StudentUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

