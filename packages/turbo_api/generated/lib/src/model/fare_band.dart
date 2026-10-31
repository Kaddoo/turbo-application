//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fare_band.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FareBand {
  /// Returns a new [FareBand] instance.
  FareBand({

    required  this.upToMeters,

    required  this.farePesewas,
  });

      /// Inclusive upper bound of the road-route distance.
          // minimum: 1
  @JsonKey(
    
    name: r'upToMeters',
    required: true,
    includeIfNull: false,
  )


  final int upToMeters;



      /// Whole cedis only (multiples of 100 pesewas) so shared-ride shares stay exact.
          // minimum: 0
  @JsonKey(
    
    name: r'farePesewas',
    required: true,
    includeIfNull: false,
  )


  final int farePesewas;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FareBand &&
      other.upToMeters == upToMeters &&
      other.farePesewas == farePesewas;

    @override
    int get hashCode =>
        upToMeters.hashCode +
        farePesewas.hashCode;

  factory FareBand.fromJson(Map<String, dynamic> json) => _$FareBandFromJson(json);

  Map<String, dynamic> toJson() => _$FareBandToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

