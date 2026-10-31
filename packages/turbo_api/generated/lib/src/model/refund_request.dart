//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refund_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RefundRequest {
  /// Returns a new [RefundRequest] instance.
  RefundRequest({

     this.amountPesewas,

    required  this.reasonCode,

    required  this.note,
  });

      /// Omit for a full refund of what was charged.
          // minimum: 0
  @JsonKey(
    
    name: r'amountPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? amountPesewas;



  @JsonKey(
    
    name: r'reasonCode',
    required: true,
    includeIfNull: false,
  )


  final RefundRequestReasonCodeEnum reasonCode;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RefundRequest &&
      other.amountPesewas == amountPesewas &&
      other.reasonCode == reasonCode &&
      other.note == note;

    @override
    int get hashCode =>
        amountPesewas.hashCode +
        reasonCode.hashCode +
        note.hashCode;

  factory RefundRequest.fromJson(Map<String, dynamic> json) => _$RefundRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RefundRequestReasonCodeEnum {
@JsonValue(r'driver_cancelled')
driverCancelled(r'driver_cancelled'),
@JsonValue(r'service_issue')
serviceIssue(r'service_issue'),
@JsonValue(r'breakdown')
breakdown(r'breakdown'),
@JsonValue(r'partial_trip')
partialTrip(r'partial_trip'),
@JsonValue(r'wrong_charge')
wrongCharge(r'wrong_charge'),
@JsonValue(r'other')
other(r'other');

const RefundRequestReasonCodeEnum(this.value);

final String value;

@override
String toString() => value;
}


