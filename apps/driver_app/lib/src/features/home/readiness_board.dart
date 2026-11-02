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
      if (worstDoc == null || d.status.index > worstDoc.status.index) worstDoc = d;
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
        label: label,
        title: value,
        semanticLabel: '$label, $value, $tag',
        onTap: ok ? null : onFix,
        // A wrap, so at large text the picture drops below the tag instead of squeezing it.
        trailing: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: TurboSpacing.sm,
          children: [
            StatusChip(
              label: tag,
              icon: ok ? Icons.check : Icons.error_outline,
              tone: ok ? StatusTone.success : StatusTone.danger,
            ),
            art,
          ],
        ),
      );
    }

    final Widget docsTile = worstDoc == null
        ? BentoTile(
            label: l10n.readinessTileDocuments,
            title: l10n.readinessDocuments,
            trailing: const Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TurboArtImage(TurboArt.identificationCard),
            ),
          )
        : tile(
            label: worstDoc.status == DocStatus.valid ? l10n.readinessTileDocuments : docName(l10n, worstDoc.type),
            value: docStatusWord(l10n, worstDoc.status),
            ok: !docsExpired,
            art: const TurboArtImage(TurboArt.identificationCard),
            fixLabel: l10n.readinessFix,
            onFix: onOpenDocuments,
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
            art: Icon(
              r.charging ? Icons.battery_charging_full : Icons.battery_std,
              size: TurboSizes.iconLg,
              color: r.batteryOk ? t.colors.textSecondary : t.colors.danger,
            ),
          ),
          docsTile,
        ),
        const SizedBox(height: TurboSpacing.md),
        pair(
          tile(
            label: l10n.readinessTileNotifications,
            value: r.notifications ? l10n.readinessOn : l10n.readinessOff,
            ok: r.notifications,
            art: const TurboArtImage(TurboArt.bell),
            fixLabel: l10n.readinessFix,
            onFix: onFixNotifications,
          ),
          tile(
            label: l10n.readinessTileInternet,
            value: r.online ? l10n.readinessConnected : l10n.readinessOffline,
            ok: r.online,
            art: const TurboArtImage(TurboArt.mobilePhone),
          ),
        ),
      ],
    );
  }
}
