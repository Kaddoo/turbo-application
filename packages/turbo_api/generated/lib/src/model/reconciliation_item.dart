//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reconciliation_item.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReconciliationItem {
  /// Returns a new [ReconciliationItem] instance.
  ReconciliationItem({

     this.providerReference,

     this.topupId,

     this.providerAmountPesewas,

     this.ourAmountPesewas,

    required  this.issue,
  });

  @JsonKey(
    
    name: r'providerReference',
    required: false,
    includeIfNull: false,
  )


  final String? providerReference;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'topupId',
    required: false,
    includeIfNull: false,
  )


  final String? topupId;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'providerAmountPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? providerAmountPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'ourAmountPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? ourAmountPesewas;



  @JsonKey(
    
    name: r'issue',
    required: true,
    includeIfNull: false,
  )


  final ReconciliationItemIssueEnum issue;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReconciliationItem &&
      other.providerReference == providerReference &&
      other.topupId == topupId &&
      other.providerAmountPesewas == providerAmountPesewas &&
      other.ourAmountPesewas == ourAmountPesewas &&
      other.issue == issue;

    @override
    int get hashCode =>
        (providerReference == null ? 0 : providerReference.hashCode) +
        (topupId == null ? 0 : topupId.hashCode) +
        (providerAmountPesewas == null ? 0 : providerAmountPesewas.hashCode) +
        (ourAmountPesewas == null ? 0 : ourAmountPesewas.hashCode) +
        issue.hashCode;

  factory ReconciliationItem.fromJson(Map<String, dynamic> json) => _$ReconciliationItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ReconciliationItemIssueEnum {
@JsonValue(r'missing_here')
missingHere(r'missing_here'),
@JsonValue(r'missing_at_provider')
missingAtProvider(r'missing_at_provider'),
@JsonValue(r'amount_mismatch')
amountMismatch(r'amount_mismatch'),
@JsonValue(r'status_mismatch')
statusMismatch(r'status_mismatch');

const ReconciliationItemIssueEnum(this.value);

final String value;

@override
String toString() => value;
}


