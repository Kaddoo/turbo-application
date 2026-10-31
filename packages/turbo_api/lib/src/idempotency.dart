import 'package:uuid/uuid.dart';

/// One key per user intention. Create it when the person confirms the action,
/// keep it, and pass the same [value] on every retry of that action.
class IdempotencyKey {
  IdempotencyKey() : value = const Uuid().v4();

  final String value;

  static const header = 'Idempotency-Key';

  Map<String, String> get headers => {header: value};
}
