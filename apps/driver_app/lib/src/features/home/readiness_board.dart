import 'package:flutter/material.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../location/location_access.dart';
import '../../core/driver_gaps.dart';
import '../duty/readiness.dart';
import '../me/documents_screen.dart';

/// "Ready to go", or the one thing in the way, then a tile for each thing the
/// phone must have before a shift. Each tile says its state with a word, not
/// only a colour, and a tile that needs fixing opens the fix when tapped.
class ReadinessBoard extends StatelessWidget {
  const ReadinessBoard({
    super.key,
    required this.readiness,
    required this.onFixLocation,
    required this.onFixNotifications,
    this.documents,
    this.shift,
    this.onOpenDocuments,
  });

  final Readiness readiness;
  final VoidCallback onFixLocation;
  final VoidCallback onFixNotifications;

  /// Null when the app cannot tell yet (CR-5).
  final List<DriverDoc>? documents;

  /// Today's shift as "07:00 – 15:00", or null while it loads.
  final String? shift;
  final VoidCallback? onOpenDocuments;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final r = readiness;
    final settingsFirst =
        r.location == DriverLocationAccess.whileInUse ||
        r.location == DriverLocationAccess.deniedForever;

    final docs = documents;
    DriverDoc? worstDoc;
    for (final d in docs ?? const <DriverDoc>[]) {
      if (worstDoc == null || d.status.index > worstDoc.status.index) {
        worstDoc = d;
      }
    }
    final docsExpired = worstDoc?.status == DocStatus.expired;

    // The single blocker, in order of what stops a shift first.
    final blocker = !r.locationOk
        ? l10n.readinessLocation
        : !r.notifications
        ? l10n.readinessNotifications
        : !r.online
        ? l10n.readinessInternet
        : !r.batteryOk
        ? l10n.readinessBattery
        : docsExpired
        ? l10n.readinessDocumentsValid
        : null;

    Widget tile({
      required String label,
      required String value,
      required bool ok,
      required Widget art,
      String? fixLabel,
      VoidCallback? onFix,
    }) {
      final tag = ok ? l10n.readinessOk : (fixLabel ?? l10n.readinessProblem);
      return BentoTile(
        stretch: true,
        label: label,
        title: value,
        semanticLabel: '$label, $value, $tag',
        onTap: ok ? null : onFix,
        tag: StatusChip(
          label: tag,
          icon: ok ? Icons.check : Icons.error_outline,
          tone: ok ? StatusTone.success : StatusTone.danger,
        ),
        trailing: art,
      );
    }

    final Widget docsTile = worstDoc == null
        ? BentoTile(
            stretch: true,
            label: l10n.readinessTileDocuments,
            title: l10n.readinessDocuments,
            trailing: const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TurboArtImage(TurboArt.identificationCard),
            ),
          )
        : tile(
            label: worstDoc.status == DocStatus.valid
                ? l10n.readinessTileDocuments
                : docName(l10n, worstDoc.type),
            value: docStatusWord(l10n, worstDoc.status),
            ok: !docsExpired,
            art: const TurboArtImage(TurboArt.identificationCard),
            fixLabel: l10n.readinessFix,
            onFix: onOpenDocuments,
          );

    Widget tick(String label) => Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: TurboSizes.iconSm, color: t.colors.success),
          const SizedBox(width: TurboSpacing.xs),
          Flexible(child: Text(label, style: text.bodyMedium)),
        ],
      ),
    );

    Widget pair(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: TurboSpacing.md),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.readinessTitle, style: text.bodySmall),
        Semantics(
          header: true,
          liveRegion: true,
          child: Text(
            blocker ?? l10n.readinessReadyToGo,
            style: text.headlineMedium?.copyWith(
              color: blocker == null ? t.colors.accentText : t.colors.danger,
            ),
          ),
        ),
        const SizedBox(height: TurboSpacing.md),
        pair(
          BentoTile(
            stretch: true,
            label: l10n.readinessTileShift,
            title: shift ?? '–',
            trailing: const TurboArtImage(TurboArt.calendar),
          ),
          tile(
            label: l10n.readinessTileLocation,
            value: switch (r.location) {
              DriverLocationAccess.always => l10n.readinessLocationAlways,
              DriverLocationAccess.whileInUse =>
                l10n.readinessLocationWhileUsing,
              _ => l10n.readinessLocationOff,
            },
            ok: r.locationOk,
            art: const TurboArtImage(TurboArt.roundPushpin),
            fixLabel: settingsFirst
                ? l10n.readinessOpenSettings
                : l10n.readinessLocationFix,
            onFix: onFixLocation,
          ),
        ),
        const SizedBox(height: TurboSpacing.md),
        pair(
          tile(
            label: l10n.readinessTileBattery,
            value: l10n.readinessBatteryPercent(r.batteryPercent),
            ok: r.batteryOk,
            art: const TurboArtImage(TurboArt.mobilePhone),
          ),
          docsTile,
        ),
        const SizedBox(height: TurboSpacing.md),
        // Fine things are a tick line; a tile appears only when it needs fixing.
        if (!r.notifications || !r.online)
          pair(
            !r.notifications
                ? tile(
                    label: l10n.readinessTileNotifications,
                    value: l10n.readinessOff,
                    ok: false,
                    art: const TurboArtImage(TurboArt.bell),
                    fixLabel: l10n.readinessFix,
                    onFix: onFixNotifications,
                  )
                : const SizedBox.shrink(),
            !r.online
                ? tile(
                    label: l10n.readinessTileInternet,
                    value: l10n.readinessOffline,
                    ok: false,
                    art: const TurboArtImage(TurboArt.warning),
                  )
                : const SizedBox.shrink(),
          ),
        if (r.notifications || r.online)
          Padding(
            padding: const EdgeInsets.only(top: TurboSpacing.md),
            child: Wrap(
              spacing: TurboSpacing.lg,
              runSpacing: TurboSpacing.sm,
              children: [
                if (r.notifications) tick(l10n.readinessNotifications),
                if (r.online) tick(l10n.readinessInternet),
              ],
            ),
          ),
      ],
    );
  }
}
