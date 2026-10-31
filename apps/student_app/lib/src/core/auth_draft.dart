import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'providers.dart';

/// What the sign-in screens share while someone is part-way through.
class AuthDraft {
  const AuthDraft({this.phone, this.resendInSeconds = 0, this.pendingCode});

  /// Full number in `+233XXXXXXXXX` form.
  final String? phone;
  final int resendInSeconds;

  /// A code that the server accepted in principle but refused until the terms
  /// are agreed (`terms_not_accepted`). Held in memory only, never stored.
  final String? pendingCode;

  AuthDraft copyWith({String? phone, int? resendInSeconds, String? pendingCode, bool clearPending = false}) =>
      AuthDraft(
        phone: phone ?? this.phone,
        resendInSeconds: resendInSeconds ?? this.resendInSeconds,
        pendingCode: clearPending ? null : (pendingCode ?? this.pendingCode),
      );
}

class AuthDraftController extends Notifier<AuthDraft> {
  @override
  AuthDraft build() => const AuthDraft();

  void set(AuthDraft draft) => state = draft;
  void reset() => state = const AuthDraft();
}

final authDraftProvider = NotifierProvider<AuthDraftController, AuthDraft>(AuthDraftController.new);

/// A stable id for this install, sent with code requests so limits apply per
/// device. Created on first use.
final deviceIdProvider = FutureProvider<String>((ref) async {
  final store = ref.read(tokenStoreProvider);
  final existing = await store.readDeviceId();
  if (existing != null) return existing;
  final id = const Uuid().v4();
  await store.writeDeviceId(id);
  return id;
});

/// Turns what a person typed into `+233XXXXXXXXX`, or null if it is not a valid
/// 9-digit Ghana number. A leading 0 and spaces are ignored.
String? normalisePhone(String input) {
  var digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('233') && digits.length == 12) digits = digits.substring(3);
  if (digits.startsWith('0')) digits = digits.substring(1);
  return digits.length == 9 ? '+233$digits' : null;
}

/// `+233241234567` shown as `+233 24 123 4567`. Never logged.
String displayPhone(String e164) {
  if (e164.length != 13) return e164;
  return '${e164.substring(0, 4)} ${e164.substring(4, 6)} ${e164.substring(6, 9)} ${e164.substring(9)}';
}
