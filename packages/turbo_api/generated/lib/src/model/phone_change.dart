//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_change.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PhoneChange {
  /// Returns a new [PhoneChange] instance.
  PhoneChange({

    required  this.newPhone,

    required  this.ticketId,

    required  this.note,
  });

  @JsonKey(
    
    name: r'newPhone',
    required: true,
    includeIfNull: false,
  )


  final String newPhone;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'ticketId',
    required: true,
    includeIfNull: false,
  )


  final String ticketId;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PhoneChange &&
      other.newPhone == newPhone &&
      other.ticketId == ticketId &&
      other.note == note;

    @override
    int get hashCode =>
        newPhone.hashCode +
        ticketId.hashCode +
        note.hashCode;

  factory PhoneChange.fromJson(Map<String, dynamic> json) => _$PhoneChangeFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneChangeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

