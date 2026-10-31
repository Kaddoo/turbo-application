//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/quote_wallet.dart';
import 'package:turbo_api_generated/src/model/ineligibility_reason.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Quote {
  /// Returns a new [Quote] instance.
  Quote({

    required  this.eligible,

     this.quoteId,

    required  this.reasons,

     this.routeDistanceMeters,

     this.routeDurationSeconds,

     this.farePesewas,

     this.pickupEtaSeconds,

     this.expiresAt,

    required  this.wallet,
  });

  @JsonKey(
    
    name: r'eligible',
    required: true,
    includeIfNull: false,
  )


  final bool eligible;



      /// Null when eligible is false.
  @JsonKey(
    
    name: r'quoteId',
    required: false,
    includeIfNull: false,
  )


  final String? quoteId;



  @JsonKey(
    
    name: r'reasons',
    required: true,
    includeIfNull: false,
  )


  final List<IneligibilityReason> reasons;



  @JsonKey(
    
    name: r'routeDistanceMeters',
    required: false,
    includeIfNull: false,
  )


  final int? routeDistanceMeters;



  @JsonKey(
    
    name: r'routeDurationSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? routeDurationSeconds;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'farePesewas',
    required: false,
    includeIfNull: false,
  )


  final int? farePesewas;



  @JsonKey(
    
    name: r'pickupEtaSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? pickupEtaSeconds;



  @JsonKey(
    
    name: r'expiresAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? expiresAt;



  @JsonKey(
    
    name: r'wallet',
    required: true,
    includeIfNull: false,
  )


  final QuoteWallet wallet;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Quote &&
      other.eligible == eligible &&
      other.quoteId == quoteId &&
      other.reasons == reasons &&
      other.routeDistanceMeters == routeDistanceMeters &&
      other.routeDurationSeconds == routeDurationSeconds &&
      other.farePesewas == farePesewas &&
      other.pickupEtaSeconds == pickupEtaSeconds &&
      other.expiresAt == expiresAt &&
      other.wallet == wallet;

    @override
    int get hashCode =>
        eligible.hashCode +
        (quoteId == null ? 0 : quoteId.hashCode) +
        reasons.hashCode +
        (routeDistanceMeters == null ? 0 : routeDistanceMeters.hashCode) +
        (routeDurationSeconds == null ? 0 : routeDurationSeconds.hashCode) +
        (farePesewas == null ? 0 : farePesewas.hashCode) +
        (pickupEtaSeconds == null ? 0 : pickupEtaSeconds.hashCode) +
        (expiresAt == null ? 0 : expiresAt.hashCode) +
        wallet.hashCode;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

