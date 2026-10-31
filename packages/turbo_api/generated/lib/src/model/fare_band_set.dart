//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/fare_band.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fare_band_set.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FareBandSet {
  /// Returns a new [FareBandSet] instance.
  FareBandSet({

    required  this.bands,
  });

  @JsonKey(
    
    name: r'bands',
    required: true,
    includeIfNull: false,
  )


  final List<FareBand> bands;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FareBandSet &&
      other.bands == bands;

    @override
    int get hashCode =>
        bands.hashCode;

  factory FareBandSet.fromJson(Map<String, dynamic> json) => _$FareBandSetFromJson(json);

  Map<String, dynamic> toJson() => _$FareBandSetToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

