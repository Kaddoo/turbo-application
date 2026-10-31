//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:turbo_api_generated/src/model/driver_ride.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_ride_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverRideList {
  /// Returns a new [DriverRideList] instance.
  DriverRideList({

    required  this.data,

    required  this.page,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<DriverRide> data;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverRideList &&
      other.data == data &&
      other.page == page;

    @override
    int get hashCode =>
        data.hashCode +
        page.hashCode;

  factory DriverRideList.fromJson(Map<String, dynamic> json) => _$DriverRideListFromJson(json);

  Map<String, dynamic> toJson() => _$DriverRideListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

