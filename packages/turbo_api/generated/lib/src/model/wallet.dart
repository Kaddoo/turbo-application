//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Wallet {
  /// Returns a new [Wallet] instance.
  Wallet({

    required  this.balancePesewas,

    required  this.reservedPesewas,

    required  this.availablePesewas,

    required  this.currency,

     this.owedPesewas,
  });

      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'balancePesewas',
    required: true,
    includeIfNull: false,
  )


  final int balancePesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'reservedPesewas',
    required: true,
    includeIfNull: false,
  )


  final int reservedPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'availablePesewas',
    required: true,
    includeIfNull: false,
  )


  final int availablePesewas;



  @JsonKey(
    
    name: r'currency',
    required: true,
    includeIfNull: false,
  )


  final WalletCurrencyEnum currency;



      /// Amount the student owes after a provider reversal. While above zero, booking is blocked (account_owes).
          // minimum: 0
  @JsonKey(
    
    name: r'owedPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? owedPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Wallet &&
      other.balancePesewas == balancePesewas &&
      other.reservedPesewas == reservedPesewas &&
      other.availablePesewas == availablePesewas &&
      other.currency == currency &&
      other.owedPesewas == owedPesewas;

    @override
    int get hashCode =>
        balancePesewas.hashCode +
        reservedPesewas.hashCode +
        availablePesewas.hashCode +
        currency.hashCode +
        (owedPesewas == null ? 0 : owedPesewas.hashCode);

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum WalletCurrencyEnum {
@JsonValue(r'GHS')
GHS(r'GHS');

const WalletCurrencyEnum(this.value);

final String value;

@override
String toString() => value;
}


