//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salary_payment.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SalaryPayment {
  /// Returns a new [SalaryPayment] instance.
  SalaryPayment({

    required  this.id,

    required  this.driverId,

    required  this.periodStart,

    required  this.periodEnd,

    required  this.amountPesewas,

    required  this.method,

     this.reference,

    required  this.paidAt,
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
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



  @JsonKey(
    
    name: r'periodStart',
    required: true,
    includeIfNull: false,
  )


  final DateTime periodStart;



  @JsonKey(
    
    name: r'periodEnd',
    required: true,
    includeIfNull: false,
  )


  final DateTime periodEnd;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final SalaryPaymentMethodEnum method;



  @JsonKey(
    
    name: r'reference',
    required: false,
    includeIfNull: false,
  )


  final String? reference;



  @JsonKey(
    
    name: r'paidAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime paidAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SalaryPayment &&
      other.id == id &&
      other.driverId == driverId &&
      other.periodStart == periodStart &&
      other.periodEnd == periodEnd &&
      other.amountPesewas == amountPesewas &&
      other.method == method &&
      other.reference == reference &&
      other.paidAt == paidAt;

    @override
    int get hashCode =>
        id.hashCode +
        driverId.hashCode +
        periodStart.hashCode +
        periodEnd.hashCode +
        amountPesewas.hashCode +
        method.hashCode +
        (reference == null ? 0 : reference.hashCode) +
        paidAt.hashCode;

  factory SalaryPayment.fromJson(Map<String, dynamic> json) => _$SalaryPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryPaymentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SalaryPaymentMethodEnum {
@JsonValue(r'bank_transfer')
bankTransfer(r'bank_transfer'),
@JsonValue(r'mobile_money')
mobileMoney(r'mobile_money'),
@JsonValue(r'cash')
cash(r'cash');

const SalaryPaymentMethodEnum(this.value);

final String value;

@override
String toString() => value;
}


