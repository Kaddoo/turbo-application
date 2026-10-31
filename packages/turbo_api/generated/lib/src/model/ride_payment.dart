//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_payment.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RidePayment {
  /// Returns a new [RidePayment] instance.
  RidePayment({

    required  this.status,

    required  this.heldPesewas,

    required  this.chargedPesewas,

    required  this.refundedPesewas,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final RidePaymentStatusEnum status;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'heldPesewas',
    required: true,
    includeIfNull: false,
  )


  final int heldPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'chargedPesewas',
    required: true,
    includeIfNull: false,
  )


  final int chargedPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'refundedPesewas',
    required: true,
    includeIfNull: false,
  )


  final int refundedPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RidePayment &&
      other.status == status &&
      other.heldPesewas == heldPesewas &&
      other.chargedPesewas == chargedPesewas &&
      other.refundedPesewas == refundedPesewas;

    @override
    int get hashCode =>
        status.hashCode +
        heldPesewas.hashCode +
        chargedPesewas.hashCode +
        refundedPesewas.hashCode;

  factory RidePayment.fromJson(Map<String, dynamic> json) => _$RidePaymentFromJson(json);

  Map<String, dynamic> toJson() => _$RidePaymentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RidePaymentStatusEnum {
@JsonValue(r'held')
held(r'held'),
@JsonValue(r'charged')
charged(r'charged'),
@JsonValue(r'released')
released(r'released'),
@JsonValue(r'refunded')
refunded(r'refunded'),
@JsonValue(r'partially_refunded')
partiallyRefunded(r'partially_refunded');

const RidePaymentStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


