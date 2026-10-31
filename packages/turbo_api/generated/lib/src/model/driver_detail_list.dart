//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/driver_detail.dart';
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_detail_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DriverDetailList {
  /// Returns a new [DriverDetailList] instance.
  DriverDetailList({

    required  this.data,

    required  this.page,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<DriverDetail> data;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DriverDetailList &&
      other.data == data &&
      other.page == page;

    @override
    int get hashCode =>
        data.hashCode +
        page.hashCode;

  factory DriverDetailList.fromJson(Map<String, dynamic> json) => _$DriverDetailListFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDetailListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

