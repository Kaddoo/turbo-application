//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topup_resolve.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TopupResolve {
  /// Returns a new [TopupResolve] instance.
  TopupResolve({

    required  this.resolution,

    required  this.note,
  });

  @JsonKey(
    
    name: r'resolution',
    required: true,
    includeIfNull: false,
  )


  final TopupResolveResolutionEnum resolution;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TopupResolve &&
      other.resolution == resolution &&
      other.note == note;

    @override
    int get hashCode =>
        resolution.hashCode +
        note.hashCode;

  factory TopupResolve.fromJson(Map<String, dynamic> json) => _$TopupResolveFromJson(json);

  Map<String, dynamic> toJson() => _$TopupResolveToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TopupResolveResolutionEnum {
@JsonValue(r'accept_received_amount')
acceptReceivedAmount(r'accept_received_amount'),
@JsonValue(r'refund_outside_system')
refundOutsideSystem(r'refund_outside_system'),
@JsonValue(r'no_action')
noAction(r'no_action');

const TopupResolveResolutionEnum(this.value);

final String value;

@override
String toString() => value;
}


