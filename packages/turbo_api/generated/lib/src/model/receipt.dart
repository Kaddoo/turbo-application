//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/receipt_line.dart';
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Receipt {
  /// Returns a new [Receipt] instance.
  Receipt({

    required  this.rideId,

    required  this.receiptNumber,

    required  this.issuedAt,

     this.pickup,

     this.dropoff,

     this.routeDistanceMeters,

     this.driverFirstName,

     this.vehiclePlate,

    required  this.lines,

    required  this.totalPesewas,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'rideId',
    required: true,
    includeIfNull: false,
  )


  final String rideId;



  @JsonKey(
    
    name: r'receiptNumber',
    required: true,
    includeIfNull: false,
  )


  final String receiptNumber;



  @JsonKey(
    
    name: r'issuedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime issuedAt;



  @JsonKey(
    
    name: r'pickup',
    required: false,
    includeIfNull: false,
  )


  final Location? pickup;



  @JsonKey(
    
    name: r'dropoff',
    required: false,
    includeIfNull: false,
  )


  final Location? dropoff;



  @JsonKey(
    
    name: r'routeDistanceMeters',
    required: false,
    includeIfNull: false,
  )


  final int? routeDistanceMeters;



  @JsonKey(
    
    name: r'driverFirstName',
    required: false,
    includeIfNull: false,
  )


  final String? driverFirstName;



  @JsonKey(
    
    name: r'vehiclePlate',
    required: false,
    includeIfNull: false,
  )


  final String? vehiclePlate;



  @JsonKey(
    
    name: r'lines',
    required: true,
    includeIfNull: false,
  )


  final List<ReceiptLine> lines;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'totalPesewas',
    required: true,
    includeIfNull: false,
  )


  final int totalPesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Receipt &&
      other.rideId == rideId &&
      other.receiptNumber == receiptNumber &&
      other.issuedAt == issuedAt &&
      other.pickup == pickup &&
      other.dropoff == dropoff &&
      other.routeDistanceMeters == routeDistanceMeters &&
      other.driverFirstName == driverFirstName &&
      other.vehiclePlate == vehiclePlate &&
      other.lines == lines &&
      other.totalPesewas == totalPesewas;

    @override
    int get hashCode =>
        rideId.hashCode +
        receiptNumber.hashCode +
        issuedAt.hashCode +
        pickup.hashCode +
        dropoff.hashCode +
        routeDistanceMeters.hashCode +
        driverFirstName.hashCode +
        vehiclePlate.hashCode +
        lines.hashCode +
        totalPesewas.hashCode;

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

