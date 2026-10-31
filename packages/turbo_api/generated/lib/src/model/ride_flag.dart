//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// Staff-only markers. driver_unreachable: no driver location for driverSilenceSeconds on an active ride. overdue: in progress for more than twice the expected duration. The last two are set on completion for review and never block the completion.
enum RideFlag {
  @JsonValue(r'driver_unreachable')
  driverUnreachable(r'driver_unreachable'),
  @JsonValue(r'overdue')
  overdue(r'overdue'),
  @JsonValue(r'completed_far_from_destination')
  completedFarFromDestination(r'completed_far_from_destination'),
  @JsonValue(r'completed_too_fast')
  completedTooFast(r'completed_too_fast');

  const RideFlag(this.value);

  final String value;

  @override
  String toString() => value;
}
