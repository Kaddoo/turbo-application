//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salary_profile.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SalaryProfile {
  /// Returns a new [SalaryProfile] instance.
  SalaryProfile({

    required  this.driverId,

    required  this.monthlySalaryPesewas,

    required  this.payPeriod,

     this.updatedAt,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: true,
    includeIfNull: false,
  )


  final String driverId;



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


  final SalaryProfilePayPeriodEnum payPeriod;



  @JsonKey(
    
    name: r'updatedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SalaryProfile &&
      other.driverId == driverId &&
      other.monthlySalaryPesewas == monthlySalaryPesewas &&
      other.payPeriod == payPeriod &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        driverId.hashCode +
        monthlySalaryPesewas.hashCode +
        payPeriod.hashCode +
        updatedAt.hashCode;

  factory SalaryProfile.fromJson(Map<String, dynamic> json) => _$SalaryProfileFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryProfileToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SalaryProfilePayPeriodEnum {
@JsonValue(r'weekly')
weekly(r'weekly'),
@JsonValue(r'biweekly')
biweekly(r'biweekly'),
@JsonValue(r'monthly')
monthly(r'monthly');

const SalaryProfilePayPeriodEnum(this.value);

final String value;

@override
String toString() => value;
}


