//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_adjustment.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WalletAdjustment {
  /// Returns a new [WalletAdjustment] instance.
  WalletAdjustment({

    required  this.amountPesewas,

    required  this.reasonCode,

    required  this.note,
  });

      /// Non-zero. Negative debits.
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


  final WalletAdjustmentReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WalletAdjustment &&
      other.amountPesewas == amountPesewas &&
      other.reasonCode == reasonCode &&
      other.note == note;

    @override
    int get hashCode =>
        amountPesewas.hashCode +
        reasonCode.hashCode +
        note.hashCode;

  factory WalletAdjustment.fromJson(Map<String, dynamic> json) => _$WalletAdjustmentFromJson(json);

  Map<String, dynamic> toJson() => _$WalletAdjustmentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum WalletAdjustmentReasonCodeEnum {
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

const WalletAdjustmentReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


