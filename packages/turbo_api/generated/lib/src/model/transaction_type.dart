//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// provider_reversal: the network reversed a top-up after it was credited. May take the wallet below zero.
enum TransactionType {
  @JsonValue(r'topup')
  topup(r'topup'),
  @JsonValue(r'ride_hold')
  rideHold(r'ride_hold'),
  @JsonValue(r'ride_release')
  rideRelease(r'ride_release'),
  @JsonValue(r'ride_charge')
  rideCharge(r'ride_charge'),
  @JsonValue(r'refund')
  refund(r'refund'),
  @JsonValue(r'adjustment')
  adjustment(r'adjustment'),
  @JsonValue(r'provider_reversal')
  providerReversal(r'provider_reversal');

  const TransactionType(this.value);

  final String value;

  @override
  String toString() => value;
}
