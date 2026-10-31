//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverUpdate {
  /// Returns a new [DriverUpdate] instance.
  DriverUpdate({

     this.fullName,

     this.status,

     this.vehicleId,
  });

  @JsonKey(
    
    name: r'fullName',
    required: false,
    includeIfNull: false,
  )


  final String? fullName;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final AccountStatus? status;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'vehicleId',
    required: false,
    includeIfNull: false,
  )


  final String? vehicleId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverUpdate &&
      other.fullName == fullName &&
      other.status == status &&
      other.vehicleId == vehicleId;

    @override
    int get hashCode =>
        fullName.hashCode +
        status.hashCode +
        (vehicleId == null ? 0 : vehicleId.hashCode);

  factory DriverUpdate.fromJson(Map<String, dynamic> json) => _$DriverUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$DriverUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

