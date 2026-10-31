//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adjustment_decision.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdjustmentDecision {
  /// Returns a new [AdjustmentDecision] instance.
  AdjustmentDecision({

     this.note,
  });

  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdjustmentDecision &&
      other.note == note;

    @override
    int get hashCode =>
        note.hashCode;

  factory AdjustmentDecision.fromJson(Map<String, dynamic> json) => _$AdjustmentDecisionFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentDecisionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

