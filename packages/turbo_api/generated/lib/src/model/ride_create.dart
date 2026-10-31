//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RideCreate {
  /// Returns a new [RideCreate] instance.
  RideCreate({

    required  this.quoteId,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'quoteId',
    required: true,
    includeIfNull: false,
  )


  final String quoteId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RideCreate &&
      other.quoteId == quoteId;

    @override
    int get hashCode =>
        quoteId.hashCode;

  factory RideCreate.fromJson(Map<String, dynamic> json) => _$RideCreateFromJson(json);

  Map<String, dynamic> toJson() => _$RideCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

