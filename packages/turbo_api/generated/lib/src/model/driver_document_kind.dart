//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum DriverDocumentKind {
  @JsonValue(r'drivers_licence')
  driversLicence(r'drivers_licence'),
  @JsonValue(r'vehicle_registration')
  vehicleRegistration(r'vehicle_registration'),
  @JsonValue(r'insurance')
  insurance(r'insurance'),
  @JsonValue(r'roadworthy')
  roadworthy(r'roadworthy');

  const DriverDocumentKind(this.value);

  final String value;

  @override
  String toString() => value;
}
