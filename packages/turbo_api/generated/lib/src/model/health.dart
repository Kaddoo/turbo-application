//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Health {
  /// Returns a new [Health] instance.
  Health({

    required  this.status,

    required  this.version,

    required  this.time,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final HealthStatusEnum status;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;



  @JsonKey(
    
    name: r'time',
    required: true,
    includeIfNull: false,
  )


  final DateTime time;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Health &&
      other.status == status &&
      other.version == version &&
      other.time == time;

    @override
    int get hashCode =>
        status.hashCode +
        version.hashCode +
        time.hashCode;

  factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);

  Map<String, dynamic> toJson() => _$HealthToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HealthStatusEnum {
@JsonValue(r'ok')
ok(r'ok'),
@JsonValue(r'degraded')
degraded(r'degraded');

const HealthStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


