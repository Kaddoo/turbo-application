import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/driver_gaps.dart';
import '../../l10n/app_localizations.dart';
import '../support/call_supervisor_button.dart';

String docName(AppLocalizations l10n, DriverDocType t) => switch (t) {
      DriverDocType.driversLicence => l10n.docDriversLicence,
      DriverDocType.vehicleRegistration => l10n.docVehicleRegistration,
      DriverDocType.insurance => l10n.docInsurance,
      DriverDocType.roadworthy => l10n.docRoadworthy,
    };

String docStatusWord(AppLocalizations l10n, DocStatus s) => switch (s) {
      DocStatus.valid => l10n.docValid,
      DocStatus.expiring => l10n.docExpiring,
      DocStatus.expired => l10n.docExpired,
    };

/// The driver's documents and when each runs out. Read only: staff add and renew them.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final docs = ref.watch(driverDocsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.docsTitle)),
      body: SafeArea(
        child: docs.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(onRetry: () => ref.invalidate(driverDocsProvider)),
          data: (list) => list == null || list.isEmpty
              ? EmptyState(art: TurboArt.identificationCard, message: list == null ? l10n.docsUnavailable : l10n.docsEmpty)
              : _List(docs: list),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.docs});

  final List<DriverDoc> docs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final needsRenewal = docs.any((d) => d.status != DocStatus.valid);
    return ListView(
      padding: const EdgeInsets.all(TurboSpacing.lg),
      children: [
        for (final (i, d) in docs.indexed)
          TurboStagger(
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: TurboSpacing.md),
              child: TurboCard(
                semanticLabel: '${docName(l10n, d.type)}, ${docStatusWord(l10n, d.status)}',
                child: Row(
                  children: [
                    const TurboArtImage(TurboArt.identificationCard),
                    const SizedBox(width: TurboSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(docName(l10n, d.type), style: text.labelLarge),
                          if (d.expiresOn != null) ...[
                            const SizedBox(height: TurboSpacing.xs),
                            Text(
                              d.status == DocStatus.expired
                                  ? l10n.docExpiredOn(DateFormat('d MMM yyyy').format(d.expiresOn!))
                                  : l10n.docExpiresOn(DateFormat('d MMM yyyy').format(d.expiresOn!)),
                              style: text.bodySmall,
                            ),
                          ],
                          const SizedBox(height: TurboSpacing.sm),
                          StatusChip(
                            label: docStatusWord(l10n, d.status),
                            icon: switch (d.status) {
                              DocStatus.valid => Icons.check,
                              DocStatus.expiring => Icons.schedule,
                              DocStatus.expired => Icons.error_outline,
                            },
                            tone: switch (d.status) {
                              DocStatus.valid => StatusTone.success,
                              DocStatus.expiring => StatusTone.warning,
                              DocStatus.expired => StatusTone.danger,
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (needsRenewal) ...[
          const SizedBox(height: TurboSpacing.sm),
          Text(l10n.docsRenewHint, style: text.bodyLarge),
          const SizedBox(height: TurboSpacing.md),
          const CallSupervisorButton(),
        ],
      ],
    );
  }
}
