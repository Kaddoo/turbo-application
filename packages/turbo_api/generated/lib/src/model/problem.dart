//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/problem_errors_inner.dart';
import 'package:turbo_api_generated/src/model/problem_code.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'problem.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Problem {
  /// Returns a new [Problem] instance.
  Problem({

     this.type = 'about:blank',

    required  this.title,

    required  this.status,

     this.detail,

     this.instance,

    required  this.code,

     this.errors,

     this.retryAfterSeconds,
  });

  @JsonKey(
    defaultValue: 'about:blank',
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final int status;



  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false,
  )


  final String? detail;



  @JsonKey(
    
    name: r'instance',
    required: false,
    includeIfNull: false,
  )


  final String? instance;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final ProblemCode code;



  @JsonKey(
    
    name: r'errors',
    required: false,
    includeIfNull: false,
  )


  final List<ProblemErrorsInner>? errors;



  @JsonKey(
    
    name: r'retryAfterSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? retryAfterSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Problem &&
      other.type == type &&
      other.title == title &&
      other.status == status &&
      other.detail == detail &&
      other.instance == instance &&
      other.code == code &&
      other.errors == errors &&
      other.retryAfterSeconds == retryAfterSeconds;

    @override
    int get hashCode =>
        type.hashCode +
        title.hashCode +
        status.hashCode +
        detail.hashCode +
        instance.hashCode +
        code.hashCode +
        errors.hashCode +
        retryAfterSeconds.hashCode;

  factory Problem.fromJson(Map<String, dynamic> json) => _$ProblemFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

