//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:turbo_api_generated/src/model/reconciliation_report.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reconciliation_report_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReconciliationReportList {
  /// Returns a new [ReconciliationReportList] instance.
  ReconciliationReportList({

    required  this.items,

    required  this.page,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<ReconciliationReport> items;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReconciliationReportList &&
      other.items == items &&
      other.page == page;

    @override
    int get hashCode =>
        items.hashCode +
        page.hashCode;

  factory ReconciliationReportList.fromJson(Map<String, dynamic> json) => _$ReconciliationReportListFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationReportListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

