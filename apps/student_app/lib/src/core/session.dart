import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../features/push/push_service.dart';
import 'providers.dart';

enum SessionStatus { signedOut, signedIn }

class SessionState {
  const SessionState.signedOut() : status = SessionStatus.signedOut, user = null;
  const SessionState.signedIn(this.user) : status = SessionStatus.signedIn;

  final SessionStatus status;
  final SessionUser? user;
}

/// Restores the session on start, keeps tokens, and refreshes on demand.
/// Build fails (not signs out) when the network is down, so a bad signal never
/// logs anyone out.
class SessionController extends AsyncNotifier<SessionState> {
  @override
  Future<SessionState> build() async {
    final saved = await ref.read(tokenStoreProvider).readRefreshToken();
    if (saved == null) return const SessionState.signedOut();
    final ok = await _rotate(saved, throwOnNetwork: true);
    return ok ? state.value ?? const SessionState.signedOut() : const SessionState.signedOut();
  }

  AuthApi get _auth => ref.read(clientProvider).api.getAuthApi();

  /// Rotates the refresh token. Returns false when the session is gone.
  Future<bool> refresh() async {
    final saved = await ref.read(tokenStoreProvider).readRefreshToken();
    if (saved == null) return false;
    return _rotate(saved, throwOnNetwork: false);
  }

  Future<bool> _rotate(String refreshToken, {required bool throwOnNetwork}) async {
    try {
      final response = await _auth.refreshTokens(refreshRequest: RefreshRequest(refreshToken: refreshToken));
      await _adopt(response.data!);
      return true;
    } catch (e) {
      final problem = problemOf(e);
      if (problem.code == ApiProblem.network || (problem.status ?? 500) >= 500) {
        if (throwOnNetwork) rethrow;
        return false;
      }
      // The server said this session is finished.
      await _clear();
      return false;
    }
  }

  /// Takes tokens from a successful sign-in.
  Future<void> signedIn(AuthTokens tokens) => _adopt(tokens);

  Future<void> _adopt(AuthTokens tokens) async {
    ref.read(accessTokenProvider.notifier).set(tokens.accessToken);
    final next = tokens.refreshToken;
    if (next != null) await ref.read(tokenStoreProvider).writeRefreshToken(next);
    state = AsyncData(SessionState.signedIn(tokens.user));
  }

  Future<void> signOut() async {
    await ref.read(pushRegistrarProvider).unregister();
    try {
      await _auth.logout();
    } catch (_) {
      // Signing out locally must always work.
    }
    await _clear();
  }

  Future<void> _clear() async {
    ref.read(accessTokenProvider.notifier).set(null);
    await ref.read(tokenStoreProvider).clear();
    state = const AsyncData(SessionState.signedOut());
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, SessionState>(SessionController.new);
