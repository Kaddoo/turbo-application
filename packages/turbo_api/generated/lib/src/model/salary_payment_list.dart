//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/salary_payment.dart';
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salary_payment_list.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SalaryPaymentList {
  /// Returns a new [SalaryPaymentList] instance.
  SalaryPaymentList({

    required  this.data,

    required  this.page,
  });

  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final List<SalaryPayment> data;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final PageInfo page;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SalaryPaymentList &&
      other.data == data &&
      other.page == page;

    @override
    int get hashCode =>
        data.hashCode +
        page.hashCode;

  factory SalaryPaymentList.fromJson(Map<String, dynamic> json) => _$SalaryPaymentListFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryPaymentListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

