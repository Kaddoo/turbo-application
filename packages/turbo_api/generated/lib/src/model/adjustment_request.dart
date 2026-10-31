//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adjustment_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdjustmentRequest {
  /// Returns a new [AdjustmentRequest] instance.
  AdjustmentRequest({

    required  this.id,

    required  this.studentId,

    required  this.amountPesewas,

    required  this.reasonCode,

     this.note,

    required  this.status,

    required  this.requestedBy,

     this.decidedBy,

    required  this.createdAt,

     this.decidedAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'studentId',
    required: true,
    includeIfNull: false,
  )


  final String studentId;



      /// Signed pesewas. Positive credits the wallet, negative debits it.
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;



  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final AdjustmentRequestReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AdjustmentRequestStatusEnum status;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'requestedBy',
    required: true,
    includeIfNull: false,
  )


  final String requestedBy;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'decidedBy',
    required: false,
    includeIfNull: false,
  )


  final String? decidedBy;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'decidedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? decidedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdjustmentRequest &&
      other.id == id &&
      other.studentId == studentId &&
      other.amountPesewas == amountPesewas &&
      other.reasonCode == reasonCode &&
      other.note == note &&
      other.status == status &&
      other.requestedBy == requestedBy &&
      other.decidedBy == decidedBy &&
      other.createdAt == createdAt &&
      other.decidedAt == decidedAt;

    @override
    int get hashCode =>
        id.hashCode +
        studentId.hashCode +
        amountPesewas.hashCode +
        reasonCode.hashCode +
        note.hashCode +
        status.hashCode +
        requestedBy.hashCode +
        (decidedBy == null ? 0 : decidedBy.hashCode) +
        createdAt.hashCode +
        (decidedAt == null ? 0 : decidedAt.hashCode);

  factory AdjustmentRequest.fromJson(Map<String, dynamic> json) => _$AdjustmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdjustmentRequestReasonCodeEnum {
@JsonValue(r'goodwill')
goodwill(r'goodwill'),
@JsonValue(r'duplicate_charge')
duplicateCharge(r'duplicate_charge'),
@JsonValue(r'provider_reconciliation')
providerReconciliation(r'provider_reconciliation'),
@JsonValue(r'correction')
correction(r'correction'),
@JsonValue(r'other')
other(r'other');

const AdjustmentRequestReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AdjustmentRequestStatusEnum {
@JsonValue(r'pending')
pending(r'pending'),
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected');

const AdjustmentRequestStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


