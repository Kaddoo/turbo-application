//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IncidentUpdate {
  /// Returns a new [IncidentUpdate] instance.
  IncidentUpdate({

    required  this.status,

     this.note,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final IncidentUpdateStatusEnum status;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IncidentUpdate &&
      other.status == status &&
      other.note == note;

    @override
    int get hashCode =>
        status.hashCode +
        note.hashCode;

  factory IncidentUpdate.fromJson(Map<String, dynamic> json) => _$IncidentUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum IncidentUpdateStatusEnum {
@JsonValue(r'acknowledged')
acknowledged(r'acknowledged'),
@JsonValue(r'resolved')
resolved(r'resolved');

const IncidentUpdateStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


