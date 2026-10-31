//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_contact.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrustedContact {
  /// Returns a new [TrustedContact] instance.
  TrustedContact({

    required  this.id,

    required  this.name,

    required  this.phone,

     this.relationship,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'relationship',
    required: false,
    includeIfNull: false,
  )


  final String? relationship;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrustedContact &&
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.relationship == relationship;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        phone.hashCode +
        (relationship == null ? 0 : relationship.hashCode);

  factory TrustedContact.fromJson(Map<String, dynamic> json) => _$TrustedContactFromJson(json);

  Map<String, dynamic> toJson() => _$TrustedContactToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

