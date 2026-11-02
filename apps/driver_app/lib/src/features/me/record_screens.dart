import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'records_tabs.dart';

final shiftsProvider = FutureProvider.autoDispose<List<Shift>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getDriverApi().listMyShifts()).data!.data.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

final attendanceProvider = FutureProvider.autoDispose<List<AttendanceRecord>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getDriverApi().listMyAttendance()).data!.data.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

final salaryProvider = FutureProvider.autoDispose<List<SalaryPayment>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getDriverApi().listMySalaryPayments()).data!.data.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

String _day(DateTime d) => DateFormat('EEE d MMM').format(d.toUtc());
String _time(DateTime d) => DateFormat('HH:mm').format(d.toUtc());

/// A read-only list screen with the four states. An optional [header] stays
/// pinned at the top while the list scrolls under it.
class _RecordList<T> extends ConsumerWidget {
  const _RecordList({
    required this.index,
    required this.title,
    required this.provider,
    required this.empty,
    required this.art,
    required this.builder,
    this.header,
    this.footer,
  });

  final int index;
  final String title;
  final FutureProvider<List<T>> provider;
  final String empty;
  final TurboArt art;
  final Widget Function(BuildContext, T) builder;

  /// The aggregate for the list, shown as a pinned bar when there is data.
  final Widget Function(BuildContext, List<T>)? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            RecordsTabs(index: index),
            Expanded(
              child: items.when(
                loading: () => const LoadingState(),
                error: (_, _) => ErrorState(message: l10n.meLoadFailed, onRetry: () => ref.invalidate(provider)),
                data: (list) => list.isEmpty
                    ? EmptyState(art: art, message: empty)
                    : RefreshIndicator(
                        onRefresh: () async => ref.invalidate(provider),
                        child: CustomScrollView(
                          slivers: [
                            if (header != null)
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _PinnedBar(
                                  // Tall enough for two lines at the largest text size.
                                  extent: MediaQuery.textScalerOf(context).scale(TurboSizes.pinnedBar) + TurboSpacing.lg,
                                  child: header!(context, list),
                                ),
                              ),
                            SliverPadding(
                              padding: const EdgeInsets.all(TurboSpacing.lg),
                              sliver: SliverList.list(
                                children: [
                                  for (var i = 0; i < list.length; i++)
                                    TurboStagger(
                                      index: i,
                                      child: Padding(padding: const EdgeInsets.only(bottom: TurboSpacing.md), child: builder(context, list[i])),
                                    ),
                                  ?footer,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A bar that stays at the top of a scrolling list.
class _PinnedBar extends SliverPersistentHeaderDelegate {
  _PinnedBar({required this.extent, required this.child});

  final double extent;
  final Widget child;

  @override
  double get minExtent => extent;
  @override
  double get maxExtent => extent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = context.turbo;
    return Container(
      color: t.colors.background,
      padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_PinnedBar old) => old.extent != extent || old.child != child;
}

/// A small label over a big number, for the pinned aggregate.
class _Aggregate extends StatelessWidget {
  const _Aggregate({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(label, style: text.bodySmall), value],
      ),
    );
  }
}

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return _RecordList<Shift>(
      index: 1,
      title: l10n.shiftsTitle,
      provider: shiftsProvider,
      empty: l10n.shiftsEmpty,
      art: TurboArt.calendar,
      builder: (context, s) {
        final (label, icon, tone) = switch (s.status) {
          ShiftStatusEnum.scheduled => (l10n.shiftScheduled, Icons.event_outlined, StatusTone.neutral),
          ShiftStatusEnum.inProgress => (l10n.shiftInProgress, Icons.play_circle_outline, StatusTone.success),
          ShiftStatusEnum.completed => (l10n.shiftCompleted, Icons.check_circle_outline, StatusTone.success),
          ShiftStatusEnum.missed => (l10n.shiftMissed, Icons.error_outline, StatusTone.danger),
        };
        return TurboCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_day(s.startsAt), style: text.labelLarge),
                    Text('${_time(s.startsAt)} – ${_time(s.endsAt)}', style: text.bodyLarge),
                  ],
                ),
              ),
              StatusChip(label: label, icon: icon, tone: tone),
            ],
          ),
        );
      },
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return _RecordList<AttendanceRecord>(
      index: 2,
      title: l10n.attendanceTitle,
      provider: attendanceProvider,
      empty: l10n.attendanceEmpty,
      art: TurboArt.alarmClock,
      header: (context, list) {
        // The week that holds today, Monday to Sunday.
        final today = clock.now().toUtc();
        final monday = DateTime.utc(today.year, today.month, today.day).subtract(Duration(days: today.weekday - 1));
        final minutes = list
            .where((a) {
              final d = a.date.toUtc();
              return !d.isBefore(monday) && d.isBefore(monday.add(const Duration(days: 7)));
            })
            .fold<int>(0, (sum, a) => sum + a.minutesWorked);
        return _Aggregate(
          label: l10n.hoursWeekLabel,
          value: Text(l10n.hoursWeekTotal(minutes ~/ 60, minutes % 60), style: text.titleLarge),
        );
      },
      footer: TextButton(
        onPressed: () => context.push('/support/new'),
        child: Text(l10n.attendanceWrong, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
      ),
      builder: (context, a) {
        final (label, icon, tone) = switch (a.status) {
          AttendanceRecordStatusEnum.late_ => (l10n.attendanceLate, Icons.schedule, StatusTone.warning),
          AttendanceRecordStatusEnum.absent => (l10n.attendanceAbsent, Icons.error_outline, StatusTone.danger),
          AttendanceRecordStatusEnum.corrected => (l10n.attendanceCorrectedChip, Icons.edit_outlined, StatusTone.neutral),
          _ => (l10n.attendanceOnTime, Icons.check_circle_outline, StatusTone.success),
        };
        return TurboCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(_day(a.date), style: text.labelLarge)),
                  StatusChip(label: label, icon: icon, tone: tone),
                ],
              ),
              const SizedBox(height: TurboSpacing.sm),
              if (a.clockInAt != null) Text(l10n.attendanceIn(_time(a.clockInAt!)), style: text.bodyLarge),
              if (a.clockOutAt != null) Text(l10n.attendanceOut(_time(a.clockOutAt!)), style: text.bodyLarge),
              Text(l10n.attendanceMinutes(a.minutesWorked), style: text.bodyMedium),
              if (a.correctionNote != null) Text(l10n.attendanceCorrected(a.correctionNote!), style: text.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return _RecordList<SalaryPayment>(
      index: 3,
      title: l10n.salaryTitle,
      provider: salaryProvider,
      empty: l10n.salaryEmpty,
      art: TurboArt.moneyBag,
      header: (context, list) {
        final year = clock.now().toUtc().year;
        final total = list.where((p) => p.paidAt.toUtc().year == year).fold<int>(0, (sum, p) => sum + p.amountPesewas);
        return _Aggregate(label: l10n.salaryYearLabel(year), value: MoneyText(total, style: text.titleLarge));
      },
      footer: Padding(
        padding: const EdgeInsets.only(top: TurboSpacing.sm),
        child: Text(l10n.salaryNote, style: text.bodySmall),
      ),
      builder: (context, p) => TurboCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.salaryPeriod(_day(p.periodStart), _day(p.periodEnd)), style: text.labelLarge),
                  Text(l10n.salaryPaid(_day(p.paidAt)), style: text.bodyMedium),
                  if (p.reference != null) Text(l10n.salaryReference(p.reference!), style: text.bodySmall),
                ],
              ),
            ),
            MoneyText(p.amountPesewas, style: text.titleLarge),
          ],
        ),
      ),
    );
  }
}
