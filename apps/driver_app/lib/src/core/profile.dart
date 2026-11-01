import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import 'providers.dart';
import 'session.dart';

/// What `GET /driver/profile` told us, or why it could not.
sealed class ProfileState {
  const ProfileState();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);
  final DriverProfile profile;
}

class ProfileTermsRequired extends ProfileState {
  const ProfileTermsRequired();
}

class ProfileSuspended extends ProfileState {
  const ProfileSuspended();
}

/// The driver's profile: duty status, vehicle, current ride. Read on start and
/// on every resume, so duty and the current ride are always the server's.
class ProfileController extends AsyncNotifier<ProfileState?> {
  @override
  Future<ProfileState?> build() async {
    final session = await ref.watch(sessionProvider.future);
    if (session.status != SessionStatus.signedIn) return null;
    return _fetch();
  }

  Future<ProfileState> _fetch() async {
    try {
      final profile = (await ref.read(clientProvider).api.getDriverApi().getDriverProfile()).data!;
      return profile.status == AccountStatus.suspended ? const ProfileSuspended() : ProfileLoaded(profile);
    } catch (e) {
      final problem = problemOf(e);
      if (problem.code == ProblemCode.termsNotAccepted.value) return const ProfileTermsRequired();
      if (problem.code == ProblemCode.accountSuspended.value) return const ProfileSuspended();
      rethrow;
    }
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(_fetch);
  }

  /// Takes a profile the server just returned (after a duty change).
  void adopt(DriverProfile profile) => state = AsyncData(ProfileLoaded(profile));
}

final profileProvider = AsyncNotifierProvider<ProfileController, ProfileState?>(ProfileController.new);

final legalProvider = FutureProvider<LegalVersions>((ref) async {
  final response = await ref.read(clientProvider).api.getMetaApi().getLegalVersions();
  return response.data!;
});
