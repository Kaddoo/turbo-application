//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_maintenance.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfigMaintenance {
  /// Returns a new [AppConfigMaintenance] instance.
  AppConfigMaintenance({

    required  this.active,

     this.message,
  });

  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'message',
    required: false,
    includeIfNull: false,
  )


  final String? message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppConfigMaintenance &&
      other.active == active &&
      other.message == message;

    @override
    int get hashCode =>
        active.hashCode +
        (message == null ? 0 : message.hashCode);

  factory AppConfigMaintenance.fromJson(Map<String, dynamic> json) => _$AppConfigMaintenanceFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigMaintenanceToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

