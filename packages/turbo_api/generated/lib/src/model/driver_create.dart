//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverCreate {
  /// Returns a new [DriverCreate] instance.
  DriverCreate({

    required  this.fullName,

    required  this.phone,

     this.email,

     this.vehicleId,
  });

  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'vehicleId',
    required: false,
    includeIfNull: false,
  )


  final String? vehicleId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverCreate &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.email == email &&
      other.vehicleId == vehicleId;

    @override
    int get hashCode =>
        fullName.hashCode +
        phone.hashCode +
        email.hashCode +
        (vehicleId == null ? 0 : vehicleId.hashCode);

  factory DriverCreate.fromJson(Map<String, dynamic> json) => _$DriverCreateFromJson(json);

  Map<String, dynamic> toJson() => _$DriverCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

