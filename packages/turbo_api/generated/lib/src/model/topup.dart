//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/topup_checkout.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topup.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Topup {
  /// Returns a new [Topup] instance.
  Topup({

    required  this.id,

     this.studentId,

    required  this.status,

    required  this.amountPesewas,

    required  this.channel,

    required  this.reference,

     this.checkout,

    required  this.createdAt,

     this.completedAt,

     this.amountReceivedPesewas,

     this.validation,

     this.flagged,

     this.flagReason,

     this.resolvedAt,
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
    required: false,
    includeIfNull: false,
  )


  final String? studentId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final TopupStatusEnum status;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;



  @JsonKey(
    
    name: r'channel',
    required: true,
    includeIfNull: false,
  )


  final TopupChannelEnum channel;



  @JsonKey(
    
    name: r'reference',
    required: true,
    includeIfNull: false,
  )


  final String reference;



  @JsonKey(
    
    name: r'checkout',
    required: false,
    includeIfNull: false,
  )


  final TopupCheckout? checkout;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'completedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? completedAt;



      /// What the provider says it collected. Credit is always this amount.
          // minimum: 0
  @JsonKey(
    
    name: r'amountReceivedPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? amountReceivedPesewas;



      /// Payaza amount_validation, lower-cased.
  @JsonKey(
    
    name: r'validation',
    required: false,
    includeIfNull: false,
  )


  final TopupValidationEnum? validation;



      /// True when validation is not exact, or the provider reversed it, or a reconciliation run found a mismatch.
  @JsonKey(
    
    name: r'flagged',
    required: false,
    includeIfNull: false,
  )


  final bool? flagged;



  @JsonKey(
    
    name: r'flagReason',
    required: false,
    includeIfNull: false,
  )


  final String? flagReason;



  @JsonKey(
    
    name: r'resolvedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? resolvedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Topup &&
      other.id == id &&
      other.studentId == studentId &&
      other.status == status &&
      other.amountPesewas == amountPesewas &&
      other.channel == channel &&
      other.reference == reference &&
      other.checkout == checkout &&
      other.createdAt == createdAt &&
      other.completedAt == completedAt &&
      other.amountReceivedPesewas == amountReceivedPesewas &&
      other.validation == validation &&
      other.flagged == flagged &&
      other.flagReason == flagReason &&
      other.resolvedAt == resolvedAt;

    @override
    int get hashCode =>
        id.hashCode +
        studentId.hashCode +
        status.hashCode +
        amountPesewas.hashCode +
        channel.hashCode +
        reference.hashCode +
        (checkout == null ? 0 : checkout.hashCode) +
        createdAt.hashCode +
        (completedAt == null ? 0 : completedAt.hashCode) +
        (amountReceivedPesewas == null ? 0 : amountReceivedPesewas.hashCode) +
        (validation == null ? 0 : validation.hashCode) +
        flagged.hashCode +
        (flagReason == null ? 0 : flagReason.hashCode) +
        (resolvedAt == null ? 0 : resolvedAt.hashCode);

  factory Topup.fromJson(Map<String, dynamic> json) => _$TopupFromJson(json);

  Map<String, dynamic> toJson() => _$TopupToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TopupStatusEnum {
@JsonValue(r'pending')
pending(r'pending'),
@JsonValue(r'succeeded')
succeeded(r'succeeded'),
@JsonValue(r'failed')
failed(r'failed'),
@JsonValue(r'abandoned')
abandoned(r'abandoned');

const TopupStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


enum TopupChannelEnum {
@JsonValue(r'mobile_money')
mobileMoney(r'mobile_money'),
@JsonValue(r'card')
card(r'card');

const TopupChannelEnum(this.value);

final String value;

@override
String toString() => value;
}


/// Payaza amount_validation, lower-cased.
enum TopupValidationEnum {
@JsonValue(r'exact')
exact(r'exact'),
@JsonValue(r'underpayment')
underpayment(r'underpayment'),
@JsonValue(r'overpayment')
overpayment(r'overpayment');

const TopupValidationEnum(this.value);

final String value;

@override
String toString() => value;
}


