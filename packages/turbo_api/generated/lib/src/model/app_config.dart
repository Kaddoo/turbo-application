//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/app_config_maintenance.dart';
import 'package:turbo_api_generated/src/model/app_config_min_version.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfig {
  /// Returns a new [AppConfig] instance.
  AppConfig({

    required  this.minVersion,

    required  this.maintenance,

    required  this.bookingsPaused,

     this.pauseMessage,
  });

  @JsonKey(
    
    name: r'minVersion',
    required: true,
    includeIfNull: false,
  )


  final AppConfigMinVersion minVersion;



  @JsonKey(
    
    name: r'maintenance',
    required: true,
    includeIfNull: false,
  )


  final AppConfigMaintenance maintenance;



  @JsonKey(
    
    name: r'bookingsPaused',
    required: true,
    includeIfNull: false,
  )


  final bool bookingsPaused;



  @JsonKey(
    
    name: r'pauseMessage',
    required: false,
    includeIfNull: false,
  )


  final String? pauseMessage;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppConfig &&
      other.minVersion == minVersion &&
      other.maintenance == maintenance &&
      other.bookingsPaused == bookingsPaused &&
      other.pauseMessage == pauseMessage;

    @override
    int get hashCode =>
        minVersion.hashCode +
        maintenance.hashCode +
        bookingsPaused.hashCode +
        (pauseMessage == null ? 0 : pauseMessage.hashCode);

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

