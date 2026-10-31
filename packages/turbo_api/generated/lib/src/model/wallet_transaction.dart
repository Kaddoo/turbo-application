//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/transaction_type.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_transaction.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WalletTransaction {
  /// Returns a new [WalletTransaction] instance.
  WalletTransaction({

    required  this.id,

    required  this.type,

    required  this.amountPesewas,

    required  this.affectsBalance,

    required  this.balanceAfterPesewas,

     this.rideId,

    required  this.description,

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
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final TransactionType type;



      /// Signed pesewas. Positive credits the wallet, negative debits it.
  @JsonKey(
    
    name: r'amountPesewas',
    required: true,
    includeIfNull: false,
  )


  final int amountPesewas;



      /// False for ride_hold and ride_release, which only move money between available and reserved.
  @JsonKey(
    
    name: r'affectsBalance',
    required: true,
    includeIfNull: false,
  )


  final bool affectsBalance;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'balanceAfterPesewas',
    required: true,
    includeIfNull: false,
  )


  final int balanceAfterPesewas;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: false,
    includeIfNull: false,
  )


  final String? rideId;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WalletTransaction &&
      other.id == id &&
      other.type == type &&
      other.amountPesewas == amountPesewas &&
      other.affectsBalance == affectsBalance &&
      other.balanceAfterPesewas == balanceAfterPesewas &&
      other.rideId == rideId &&
      other.description == description &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        amountPesewas.hashCode +
        affectsBalance.hashCode +
        balanceAfterPesewas.hashCode +
        (rideId == null ? 0 : rideId.hashCode) +
        description.hashCode +
        createdAt.hashCode;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => _$WalletTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

