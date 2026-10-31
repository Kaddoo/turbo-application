import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';
import '../verification/draft.dart' show Compressor;

final ticketsProvider = FutureProvider.autoDispose<List<SupportTicket>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getSupportApi().listMySupportTickets()).data!.data.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

final ticketProvider = FutureProvider.autoDispose.family<SupportTicket, String>((ref, id) async {
  try {
    return (await ref.read(clientProvider).api.getSupportApi().getMySupportTicket(id: id)).data!;
  } catch (e) {
    throw problemOf(e);
  }
});

/// Sends a support attachment to private storage and returns its upload id.
Future<String> uploadAttachment({
  required TurboClient client,
  required Dio http,
  required Compressor compress,
  required Uint8List raw,
}) async {
  final bytes = await compress(raw);
  final slot = (await client.api.getUploadsApi().createUpload(
            uploadRequest: UploadRequest(
              purpose: UploadRequestPurposeEnum.supportAttachment,
              contentType: UploadRequestContentTypeEnum.imageSlashJpeg,
              sizeBytes: bytes.length,
            ),
          ))
      .data!;
  await http.put<void>(
        slot.uploadUrl,
        data: Stream.fromIterable([bytes]),
        options: Options(method: slot.method.value, headers: {
          ...?slot.headers,
          Headers.contentLengthHeader: bytes.length,
          Headers.contentTypeHeader: 'image/jpeg',
        }),
      );
  return slot.uploadId;
}
