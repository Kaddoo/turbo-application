import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import 'providers.dart';
import 'session.dart';

/// What `GET /me` told us, or why it could not.
sealed class MeState {
  const MeState();
}

class MeLoaded extends MeState {
  const MeLoaded(this.student);
  final Student student;
}

class MeTermsRequired extends MeState {
  const MeTermsRequired();
}

class MeSuspended extends MeState {
  const MeSuspended();
}

/// Fetches the profile once signed in. Rebuilds when the session changes.
class MeController extends AsyncNotifier<MeState?> {
  @override
  Future<MeState?> build() async {
    final session = await ref.watch(sessionProvider.future);
    if (session.status != SessionStatus.signedIn) return null;
    return _fetch();
  }

  Future<MeState> _fetch() async {
    try {
      final response = await ref.read(clientProvider).api.getStudentApi().getMe();
      return MeLoaded(response.data!);
    } catch (e) {
      final problem = problemOf(e);
      if (problem.code == ProblemCode.termsNotAccepted.value) return const MeTermsRequired();
      if (problem.code == ProblemCode.accountSuspended.value) return const MeSuspended();
      rethrow;
    }
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(_fetch);
  }
}

final meProvider = AsyncNotifierProvider<MeController, MeState?>(MeController.new);

final legalProvider = FutureProvider<LegalVersions>((ref) async {
  final response = await ref.read(clientProvider).api.getMetaApi().getLegalVersions();
  return response.data!;
});
