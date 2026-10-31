//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum VerificationStatus {
  @JsonValue(r'not_submitted')
  notSubmitted(r'not_submitted'),
  @JsonValue(r'pending')
  pending(r'pending'),
  @JsonValue(r'approved')
  approved(r'approved'),
  @JsonValue(r'needs_attention')
  needsAttention(r'needs_attention'),
  @JsonValue(r'rejected')
  rejected(r'rejected');

  const VerificationStatus(this.value);

  final String value;

  @override
  String toString() => value;
}
