//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:turbo_api_generated/src/model/adjustment_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adjustment_request_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdjustmentRequestList {
  /// Returns a new [AdjustmentRequestList] instance.
  AdjustmentRequestList({

    required  this.items,

    required  this.page,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<AdjustmentRequest> items;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdjustmentRequestList &&
      other.items == items &&
      other.page == page;

    @override
    int get hashCode =>
        items.hashCode +
        page.hashCode;

  factory AdjustmentRequestList.fromJson(Map<String, dynamic> json) => _$AdjustmentRequestListFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentRequestListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

