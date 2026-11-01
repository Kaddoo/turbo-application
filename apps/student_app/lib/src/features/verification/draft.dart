import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';
import 'ghana_card.dart';
import 'image_quality.dart';

enum DocKind {
  ghanaCardFront(UploadRequestPurposeEnum.ghanaCardFront),
  ghanaCardBack(UploadRequestPurposeEnum.ghanaCardBack),
  studentId(UploadRequestPurposeEnum.studentId),
  selfie(UploadRequestPurposeEnum.selfieWithCard);

  const DocKind(this.purpose);
  final UploadRequestPurposeEnum purpose;
}

enum DocStatus { empty, uploading, uploaded, failed }

@immutable
class DocState {
  const DocState({this.status = DocStatus.empty, this.progress = 0, this.uploadId, this.preview, this.errorCode});

  final DocStatus status;
  final double progress;
  final String? uploadId;

  /// The photo as sent, for the thumbnail. Held in memory only.
  final Uint8List? preview;
  final String? errorCode;

  DocState copyWith({DocStatus? status, double? progress, String? uploadId, Uint8List? preview, String? errorCode}) =>
      DocState(
        status: status ?? this.status,
        progress: progress ?? this.progress,
        uploadId: uploadId ?? this.uploadId,
        preview: preview ?? this.preview,
        errorCode: errorCode,
      );
}

@immutable
class VerificationDraft {
  const VerificationDraft({
    this.fullName = '',
    this.ghanaCard = '',
    this.studentIdNumber = '',
    this.docs = const {},
    this.restored = false,
  });

  final String fullName;
  final String ghanaCard;
  final String studentIdNumber;
  final Map<DocKind, DocState> docs;

  /// True once anything saved from an earlier run has been read.
  final bool restored;

  DocState doc(DocKind kind) => docs[kind] ?? const DocState();

  bool get detailsValid =>
      fullName.trim().length >= 2 && studentIdNumber.trim().isNotEmpty && isValidGhanaCardNumber(ghanaCard);

  bool get allUploaded => DocKind.values.every((k) => doc(k).status == DocStatus.uploaded);

  bool get anyUploading => DocKind.values.any((k) => doc(k).status == DocStatus.uploading);

  bool get canSubmit => detailsValid && allUploaded;

  VerificationDraft copyWith({
    String? fullName,
    String? ghanaCard,
    String? studentIdNumber,
    Map<DocKind, DocState>? docs,
    bool? restored,
  }) =>
      VerificationDraft(
        fullName: fullName ?? this.fullName,
        ghanaCard: ghanaCard ?? this.ghanaCard,
        studentIdNumber: studentIdNumber ?? this.studentIdNumber,
        docs: docs ?? this.docs,
        restored: restored ?? this.restored,
      );
}

/// Keeps what was typed and which uploads finished, so closing the app part-way
/// loses nothing but photos that had not been sent. Photos are never stored.
abstract class DraftStore {
  Future<String?> read();
  Future<void> write(String json);
  Future<void> clear();
}

class SecureDraftStore implements DraftStore {
  const SecureDraftStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;
  static const _key = 'verification_draft';

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String json) => _storage.write(key: _key, value: json);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class MemoryDraftStore implements DraftStore {
  MemoryDraftStore([this.value]);

  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String json) async => value = json;

  @override
  Future<void> clear() async => value = null;
}

typedef Compressor = Future<Uint8List> Function(Uint8List bytes);

/// Shrinks photos before upload. Overridden in widget tests, where isolates
/// do not run under fake time.
final photoCompressorProvider = Provider<Compressor>((_) => compressForUpload);

final draftStoreProvider = Provider<DraftStore>((_) => const SecureDraftStore());

/// Plain HTTP client for the signed upload URL. It carries no auth header and
/// its URLs are never logged.
final uploadHttpProvider = Provider<Dio>((_) => Dio(BaseOptions(connectTimeout: const Duration(seconds: 15))));

class VerificationController extends Notifier<VerificationDraft> {
  final Map<DocKind, Uint8List> _pending = {};

  @override
  VerificationDraft build() {
    _restore();
    return const VerificationDraft();
  }

  DraftStore get _store => ref.read(draftStoreProvider);

  Future<void> _restore() async {
    final raw = await _store.read();
    if (raw == null) {
      state = state.copyWith(restored: true);
      return;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final ids = (json['uploads'] as Map<String, dynamic>? ?? {}).cast<String, String>();
      state = VerificationDraft(
        fullName: json['fullName'] as String? ?? '',
        ghanaCard: json['ghanaCard'] as String? ?? '',
        studentIdNumber: json['studentId'] as String? ?? '',
        restored: true,
        docs: {
          for (final k in DocKind.values)
            if (ids[k.name] != null) k: DocState(status: DocStatus.uploaded, progress: 1, uploadId: ids[k.name]),
        },
      );
    } catch (_) {
      await _store.clear();
      state = state.copyWith(restored: true);
    }
  }

  Future<void> _save() => _store.write(jsonEncode({
        'fullName': state.fullName,
        'ghanaCard': state.ghanaCard,
        'studentId': state.studentIdNumber,
        'uploads': {
          for (final e in state.docs.entries)
            if (e.value.status == DocStatus.uploaded && e.value.uploadId != null) e.key.name: e.value.uploadId,
        },
      }));

  void setDetails({String? fullName, String? ghanaCard, String? studentIdNumber}) {
    state = state.copyWith(fullName: fullName, ghanaCard: ghanaCard, studentIdNumber: studentIdNumber);
    _save();
  }

  void _setDoc(DocKind kind, DocState doc) {
    state = state.copyWith(docs: {...state.docs, kind: doc});
  }

  /// Compresses and sends a photo. The result is in [state].
  Future<void> addPhoto(DocKind kind, Uint8List raw) async {
    final bytes = await ref.read(photoCompressorProvider)(raw);
    _pending[kind] = bytes;
    await _upload(kind);
  }

  Future<void> retry(DocKind kind) async {
    if (_pending[kind] != null) await _upload(kind);
  }

  void remove(DocKind kind) {
    _pending.remove(kind);
    state = state.copyWith(docs: {...state.docs}..remove(kind));
    _save();
  }

  Future<void> _upload(DocKind kind) async {
    final bytes = _pending[kind]!;
    _setDoc(kind, DocState(status: DocStatus.uploading, preview: bytes));
    try {
      final slot = (await ref.read(clientProvider).api.getUploadsApi().createUpload(
                uploadRequest: UploadRequest(
                  purpose: kind.purpose,
                  contentType: UploadRequestContentTypeEnum.imageSlashJpeg,
                  sizeBytes: bytes.length,
                ),
              ))
          .data!;
      await ref.read(uploadHttpProvider).put<void>(
            slot.uploadUrl,
            data: Stream.fromIterable([bytes]),
            options: Options(
              method: slot.method.value,
              headers: {
                ...?slot.headers,
                Headers.contentLengthHeader: bytes.length,
                Headers.contentTypeHeader: 'image/jpeg',
              },
            ),
            onSendProgress: (sent, total) {
              if (total > 0) _setDoc(kind, state.doc(kind).copyWith(progress: sent / total));
            },
          );
      _setDoc(kind, DocState(status: DocStatus.uploaded, progress: 1, uploadId: slot.uploadId, preview: bytes));
      _pending.remove(kind);
      await _save();
    } catch (e) {
      final code = problemOf(e).code;
      _setDoc(kind, DocState(status: DocStatus.failed, preview: bytes, errorCode: code));
    }
  }

  /// Sends the details and the uploaded photos. Throws [ApiProblem] on failure.
  Future<VerificationState> submit() async {
    final d = state;
    try {
      final response = await ref.read(clientProvider).api.getVerificationApi().submitVerification(
            verificationSubmission: VerificationSubmission(
              fullName: d.fullName.trim(),
              studentIdNumber: d.studentIdNumber.trim(),
              ghanaCardNumber: d.ghanaCard,
              ghanaCardFrontUploadId: d.doc(DocKind.ghanaCardFront).uploadId!,
              ghanaCardBackUploadId: d.doc(DocKind.ghanaCardBack).uploadId!,
              studentIdUploadId: d.doc(DocKind.studentId).uploadId!,
              selfieUploadId: d.doc(DocKind.selfie).uploadId!,
            ),
          );
      // Sent: the photos are the server's now. Keep the typed details so a
      // later "send again" starts with them.
      _pending.clear();
      state = state.copyWith(docs: const {});
      await _save();
      return response.data!;
    } catch (e) {
      final problem = problemOf(e);
      if (problem.code == ProblemCode.uploadExpired.value) {
        // Which photo expired is not said, so all must be taken again.
        _pending.clear();
        state = state.copyWith(docs: const {});
        await _save();
      }
      throw problem;
    }
  }
}

final verificationProvider = NotifierProvider<VerificationController, VerificationDraft>(VerificationController.new);

/// The server's view, for the status screen. Refreshed by the screen.
final verificationStateProvider = FutureProvider.autoDispose<VerificationState>((ref) async {
  final response = await ref.read(clientProvider).api.getVerificationApi().getMyVerification();
  return response.data!;
});
