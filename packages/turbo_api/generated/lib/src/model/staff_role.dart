//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum StaffRole {
  @JsonValue(r'super_admin')
  superAdmin(r'super_admin'),
  @JsonValue(r'verifier')
  verifier(r'verifier'),
  @JsonValue(r'dispatcher')
  dispatcher(r'dispatcher'),
  @JsonValue(r'finance')
  finance(r'finance'),
  @JsonValue(r'support')
  support(r'support'),
  @JsonValue(r'hr')
  hr(r'hr');

  const StaffRole(this.value);

  final String value;

  @override
  String toString() => value;
}
