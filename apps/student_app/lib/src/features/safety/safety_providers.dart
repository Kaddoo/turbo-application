import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';

const maxTrustedContacts = 3;

class ContactsController extends AsyncNotifier<List<TrustedContact>> {
  @override
  Future<List<TrustedContact>> build() => _load();

  StudentApi get _api => ref.read(clientProvider).api.getStudentApi();

  Future<List<TrustedContact>> _load() async {
    try {
      return (await _api.listTrustedContacts()).data!.data.toList();
    } catch (e) {
      throw problemOf(e);
    }
  }

  Future<void> add({required String name, required String phone, String? relationship}) async {
    try {
      await _api.createTrustedContact(
        trustedContactCreate: TrustedContactCreate(
          name: name,
          phone: phone,
          relationship: (relationship ?? '').trim().isEmpty ? null : relationship!.trim(),
        ),
      );
    } catch (e) {
      throw problemOf(e);
    }
    state = AsyncData(await _load());
  }

  Future<void> remove(String id) async {
    try {
      await _api.deleteTrustedContact(id: id);
    } catch (e) {
      throw problemOf(e);
    }
    state = AsyncData(await _load());
  }

  Future<void> reload() async => state = await AsyncValue.guard(_load);
}

final contactsProvider = AsyncNotifierProvider<ContactsController, List<TrustedContact>>(ContactsController.new);
