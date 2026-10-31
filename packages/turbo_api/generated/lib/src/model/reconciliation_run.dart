//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reconciliation_run.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReconciliationRun {
  /// Returns a new [ReconciliationRun] instance.
  ReconciliationRun({

    required  this.statementUploadId,

    required  this.periodFrom,

    required  this.periodTo,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'statementUploadId',
    required: true,
    includeIfNull: false,
  )


  final String statementUploadId;



  @JsonKey(
    
    name: r'periodFrom',
    required: true,
    includeIfNull: false,
  )


  final DateTime periodFrom;



  @JsonKey(
    
    name: r'periodTo',
    required: true,
    includeIfNull: false,
  )


  final DateTime periodTo;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReconciliationRun &&
      other.statementUploadId == statementUploadId &&
      other.periodFrom == periodFrom &&
      other.periodTo == periodTo;

    @override
    int get hashCode =>
        statementUploadId.hashCode +
        periodFrom.hashCode +
        periodTo.hashCode;

  factory ReconciliationRun.fromJson(Map<String, dynamic> json) => _$ReconciliationRunFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationRunToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

