//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_contact_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrustedContactCreate {
  /// Returns a new [TrustedContactCreate] instance.
  TrustedContactCreate({

    required  this.name,

    required  this.phone,

     this.relationship,
  });

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
    bool operator ==(Object other) => identical(this, other) || other is TrustedContactCreate &&
      other.name == name &&
      other.phone == phone &&
      other.relationship == relationship;

    @override
    int get hashCode =>
        name.hashCode +
        phone.hashCode +
        relationship.hashCode;

  factory TrustedContactCreate.fromJson(Map<String, dynamic> json) => _$TrustedContactCreateFromJson(json);

  Map<String, dynamic> toJson() => _$TrustedContactCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

