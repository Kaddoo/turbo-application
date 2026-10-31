//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'destination_change_confirm.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DestinationChangeConfirm {
  /// Returns a new [DestinationChangeConfirm] instance.
  DestinationChangeConfirm({

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
    bool operator ==(Object other) => identical(this, other) || other is DestinationChangeConfirm &&
      other.quoteId == quoteId;

    @override
    int get hashCode =>
        quoteId.hashCode;

  factory DestinationChangeConfirm.fromJson(Map<String, dynamic> json) => _$DestinationChangeConfirmFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationChangeConfirmToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

