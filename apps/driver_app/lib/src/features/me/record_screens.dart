import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

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

/// A read-only list screen with the four states.
class _RecordList<T> extends ConsumerWidget {
  const _RecordList({required this.title, required this.provider, required this.empty, required this.builder, this.footer});

  final String title;
  final FutureProvider<List<T>> provider;
  final String empty;
  final Widget Function(BuildContext, T) builder;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: items.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(message: l10n.meLoadFailed, onRetry: () => ref.invalidate(provider)),
          data: (list) => list.isEmpty
              ? EmptyState(icon: Icons.inbox_outlined, message: empty)
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(provider),
                  child: ListView(
                    padding: const EdgeInsets.all(TurboSpacing.lg),
                    children: [
                      for (final item in list) Padding(padding: const EdgeInsets.only(bottom: TurboSpacing.md), child: builder(context, item)),
                      ?footer,
                    ],
                  ),
                ),
        ),
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
      title: l10n.shiftsTitle,
      provider: shiftsProvider,
      empty: l10n.shiftsEmpty,
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
      title: l10n.attendanceTitle,
      provider: attendanceProvider,
      empty: l10n.attendanceEmpty,
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
      title: l10n.salaryTitle,
      provider: salaryProvider,
      empty: l10n.salaryEmpty,
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
