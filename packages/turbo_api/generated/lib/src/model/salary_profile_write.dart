//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salary_profile_write.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SalaryProfileWrite {
  /// Returns a new [SalaryProfileWrite] instance.
  SalaryProfileWrite({

    required  this.monthlySalaryPesewas,

    required  this.payPeriod,
  });

      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'monthlySalaryPesewas',
    required: true,
    includeIfNull: false,
  )


  final int monthlySalaryPesewas;



  @JsonKey(
    
    name: r'payPeriod',
    required: true,
    includeIfNull: false,
  )


  final SalaryProfileWritePayPeriodEnum payPeriod;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SalaryProfileWrite &&
      other.monthlySalaryPesewas == monthlySalaryPesewas &&
      other.payPeriod == payPeriod;

    @override
    int get hashCode =>
        monthlySalaryPesewas.hashCode +
        payPeriod.hashCode;

  factory SalaryProfileWrite.fromJson(Map<String, dynamic> json) => _$SalaryProfileWriteFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryProfileWriteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SalaryProfileWritePayPeriodEnum {
@JsonValue(r'weekly')
weekly(r'weekly'),
@JsonValue(r'biweekly')
biweekly(r'biweekly'),
@JsonValue(r'monthly')
monthly(r'monthly');

const SalaryProfileWritePayPeriodEnum(this.value);

final String value;

@override
String toString() => value;
}


