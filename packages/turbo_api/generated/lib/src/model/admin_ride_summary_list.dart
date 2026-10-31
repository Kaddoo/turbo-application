//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/admin_ride_summary.dart';
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_ride_summary_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminRideSummaryList {
  /// Returns a new [AdminRideSummaryList] instance.
  AdminRideSummaryList({

    required  this.data,

    required  this.page,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<AdminRideSummary> data;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminRideSummaryList &&
      other.data == data &&
      other.page == page;

    @override
    int get hashCode =>
        data.hashCode +
        page.hashCode;

  factory AdminRideSummaryList.fromJson(Map<String, dynamic> json) => _$AdminRideSummaryListFromJson(json);

  Map<String, dynamic> toJson() => _$AdminRideSummaryListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

