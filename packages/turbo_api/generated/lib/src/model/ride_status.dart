//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum RideStatus {
  @JsonValue(r'searching')
  searching(r'searching'),
  @JsonValue(r'assigned')
  assigned(r'assigned'),
  @JsonValue(r'driver_arrived')
  driverArrived(r'driver_arrived'),
  @JsonValue(r'in_progress')
  inProgress(r'in_progress'),
  @JsonValue(r'completed')
  completed(r'completed'),
  @JsonValue(r'cancelled')
  cancelled(r'cancelled');

  const RideStatus(this.value);

  final String value;

  @override
  String toString() => value;
}
