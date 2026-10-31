//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote_wallet.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuoteWallet {
  /// Returns a new [QuoteWallet] instance.
  QuoteWallet({

    required  this.availablePesewas,

    required  this.sufficient,

    required  this.shortfallPesewas,
  });

      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'availablePesewas',
    required: true,
    includeIfNull: false,
  )


  final int availablePesewas;



  @JsonKey(
    
    name: r'sufficient',
    required: true,
    includeIfNull: false,
  )


  final bool sufficient;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'shortfallPesewas',
    required: true,
    includeIfNull: false,
  )


  final int shortfallPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuoteWallet &&
      other.availablePesewas == availablePesewas &&
      other.sufficient == sufficient &&
      other.shortfallPesewas == shortfallPesewas;

    @override
    int get hashCode =>
        availablePesewas.hashCode +
        sufficient.hashCode +
        shortfallPesewas.hashCode;

  factory QuoteWallet.fromJson(Map<String, dynamic> json) => _$QuoteWalletFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteWalletToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

