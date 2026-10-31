//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/reconciliation_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reconciliation_report.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReconciliationReport {
  /// Returns a new [ReconciliationReport] instance.
  ReconciliationReport({

    required  this.id,

    required  this.periodFrom,

    required  this.periodTo,

    required  this.matchedCount,

    required  this.providerTotalPesewas,

    required  this.ourTotalPesewas,

    required  this.exceptions,

    required  this.createdAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'matchedCount',
    required: true,
    includeIfNull: false,
  )


  final int matchedCount;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'providerTotalPesewas',
    required: true,
    includeIfNull: false,
  )


  final int providerTotalPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'ourTotalPesewas',
    required: true,
    includeIfNull: false,
  )


  final int ourTotalPesewas;



  @JsonKey(
    
    name: r'exceptions',
    required: true,
    includeIfNull: false,
  )


  final List<ReconciliationItem> exceptions;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReconciliationReport &&
      other.id == id &&
      other.periodFrom == periodFrom &&
      other.periodTo == periodTo &&
      other.matchedCount == matchedCount &&
      other.providerTotalPesewas == providerTotalPesewas &&
      other.ourTotalPesewas == ourTotalPesewas &&
      other.exceptions == exceptions &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        periodFrom.hashCode +
        periodTo.hashCode +
        matchedCount.hashCode +
        providerTotalPesewas.hashCode +
        ourTotalPesewas.hashCode +
        exceptions.hashCode +
        createdAt.hashCode;

  factory ReconciliationReport.fromJson(Map<String, dynamic> json) => _$ReconciliationReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationReportToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

