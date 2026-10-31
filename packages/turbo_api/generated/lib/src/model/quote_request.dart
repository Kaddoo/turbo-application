//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QuoteRequest {
  /// Returns a new [QuoteRequest] instance.
  QuoteRequest({

    required  this.pickup,

    required  this.dropoff,
  });

  @JsonKey(
    
    name: r'pickup',
    required: true,
    includeIfNull: false,
  )


  final Location pickup;



  @JsonKey(
    
    name: r'dropoff',
    required: true,
    includeIfNull: false,
  )


  final Location dropoff;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QuoteRequest &&
      other.pickup == pickup &&
      other.dropoff == dropoff;

    @override
    int get hashCode =>
        pickup.hashCode +
        dropoff.hashCode;

  factory QuoteRequest.fromJson(Map<String, dynamic> json) => _$QuoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

