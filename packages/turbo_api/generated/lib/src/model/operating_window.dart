//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operating_window.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OperatingWindow {
  /// Returns a new [OperatingWindow] instance.
  OperatingWindow({

    required  this.dayOfWeek,

    required  this.opensAt,

    required  this.closesAt,
  });

      /// 0 = Sunday
          // minimum: 0
          // maximum: 6
  @JsonKey(
    
    name: r'dayOfWeek',
    required: true,
    includeIfNull: false,
  )


  final int dayOfWeek;



  @JsonKey(
    
    name: r'opensAt',
    required: true,
    includeIfNull: false,
  )


  final String opensAt;



  @JsonKey(
    
    name: r'closesAt',
    required: true,
    includeIfNull: false,
  )


  final String closesAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OperatingWindow &&
      other.dayOfWeek == dayOfWeek &&
      other.opensAt == opensAt &&
      other.closesAt == closesAt;

    @override
    int get hashCode =>
        dayOfWeek.hashCode +
        opensAt.hashCode +
        closesAt.hashCode;

  factory OperatingWindow.fromJson(Map<String, dynamic> json) => _$OperatingWindowFromJson(json);

  Map<String, dynamic> toJson() => _$OperatingWindowToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

