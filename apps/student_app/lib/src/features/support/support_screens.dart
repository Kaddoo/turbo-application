import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../verification/draft.dart' show photoCompressorProvider, uploadHttpProvider;
import '../verification/photo_capturer.dart';
import 'support_providers.dart';

String ticketStatusLabel(AppLocalizations l10n, String status) => switch (status) {
      'open' => l10n.supportStatusOpen,
      'in_progress' => l10n.supportStatusProgress,
      'waiting_on_user' => l10n.supportStatusWaiting,
      'resolved' => l10n.supportStatusResolved,
      _ => l10n.supportStatusClosed,
    };

class SupportListScreen extends ConsumerWidget {
  const SupportListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final tickets = ref.watch(ticketsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: tickets.when(
                loading: () => const LoadingState(),
                error: (_, _) => ErrorState(message: l10n.supportLoadFailed, onRetry: () => ref.invalidate(ticketsProvider)),
                data: (list) => list.isEmpty
                    ? EmptyState(art: TurboArt.speechBalloon, message: l10n.supportEmpty)
                    : RefreshIndicator(
                        onRefresh: () async => ref.invalidate(ticketsProvider),
                        child: ListView(
                          padding: const EdgeInsets.all(TurboSpacing.lg),
                          children: [
                            Text(l10n.supportMine, style: text.titleLarge),
                            const SizedBox(height: TurboSpacing.sm),
                            for (final tk in list)
                              Padding(
                                padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                                child: TurboCard(
                                  onTap: () => context.push('/support/${tk.id}'),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(tk.subject, style: text.labelLarge),
                                            Text(DateFormat('d MMM, HH:mm').format(tk.updatedAt.toUtc()), style: text.bodySmall),
                                          ],
                                        ),
                                      ),
                                      StatusChip(label: ticketStatusLabel(l10n, tk.status.value), icon: Icons.chat_bubble_outline),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.lg),
              child: TurboButton(label: l10n.supportNew, onPressed: () => context.push('/support/new')),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTicketScreen extends ConsumerStatefulWidget {
  const NewTicketScreen({super.key, this.rideId});

  final String? rideId;

  @override
  ConsumerState<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends ConsumerState<NewTicketScreen> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  SupportTicketCreateCategoryEnum? _category;
  final _uploads = <String>[];
  bool _busy = false;
  bool _photoBusy = false;
  String? _error;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final l10n = AppLocalizations.of(context);
    final bytes = await ref.read(photoCapturerProvider).captureFree(context);
    if (bytes == null) return;
    setState(() => _photoBusy = true);
    try {
      final id = await uploadAttachment(
        client: ref.read(clientProvider),
        http: ref.read(uploadHttpProvider),
        compress: ref.read(photoCompressorProvider),
        raw: bytes,
      );
      if (mounted) setState(() => _uploads.add(id));
    } catch (_) {
      if (mounted) setState(() => _error = l10n.supportPhotoFailed);
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final category = _category;
    if (category == null || _message.text.trim().isEmpty) {
      setState(() => _error = l10n.supportNeedFields);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final subject = _subject.text.trim().length >= 3 ? _subject.text.trim() : _label(l10n, category);
      await ref.read(clientProvider).api.getSupportApi().createSupportTicket(
            supportTicketCreate: SupportTicketCreate(
              category: category,
              subject: subject,
              message: _message.text.trim(),
              rideId: widget.rideId,
              uploadIds: _uploads.isEmpty ? null : List<String>.of(_uploads),
            ),
          );
      ref.invalidate(ticketsProvider);
      if (mounted) {
        showTurboToast(context, l10n.supportSent);
        context.pop();
      }
    } catch (e) {
      if (mounted) setState(() => _error = problemMessage(l10n, problemOf(e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _label(AppLocalizations l10n, SupportTicketCreateCategoryEnum c) => switch (c) {
        SupportTicketCreateCategoryEnum.safety => l10n.catSafety,
        SupportTicketCreateCategoryEnum.driverConduct => l10n.catDriver,
        SupportTicketCreateCategoryEnum.vehicle => l10n.catVehicle,
        SupportTicketCreateCategoryEnum.wrongCharge => l10n.catWrongCharge,
        SupportTicketCreateCategoryEnum.paymentProblem => l10n.catPayment,
        SupportTicketCreateCategoryEnum.lostItem => l10n.catLostItem,
        SupportTicketCreateCategoryEnum.account => l10n.catAccount,
        SupportTicketCreateCategoryEnum.phoneChange => l10n.catPhoneChange,
        _ => l10n.catOther,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    const shown = [
      SupportTicketCreateCategoryEnum.safety,
      SupportTicketCreateCategoryEnum.driverConduct,
      SupportTicketCreateCategoryEnum.vehicle,
      SupportTicketCreateCategoryEnum.wrongCharge,
      SupportTicketCreateCategoryEnum.paymentProblem,
      SupportTicketCreateCategoryEnum.lostItem,
      SupportTicketCreateCategoryEnum.account,
      SupportTicketCreateCategoryEnum.phoneChange,
      SupportTicketCreateCategoryEnum.other,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportNew)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TurboSpacing.lg),
                children: [
                  Semantics(header: true, child: Text(l10n.supportAbout, style: text.titleSmall)),
                  const SizedBox(height: TurboSpacing.sm),
                  Wrap(
                    spacing: TurboSpacing.sm,
                    runSpacing: TurboSpacing.sm,
                    children: [
                      for (final c in shown)
                        TurboChip(
                          label: _label(l10n, c),
                          selected: _category == c,
                          onTap: () => setState(() {
                            _category = c;
                            _error = null;
                          }),
                        ),
                    ],
                  ),
                  if (widget.rideId != null) ...[
                    const SizedBox(height: TurboSpacing.md),
                    StatusChip(label: l10n.supportRide, icon: Icons.directions_car_outlined),
                  ],
                  const SizedBox(height: TurboSpacing.lg),
                  TurboTextField(label: l10n.supportSubject, controller: _subject, textInputAction: TextInputAction.next),
                  const SizedBox(height: TurboSpacing.md),
                  TurboTextField(
                    label: l10n.supportMessage,
                    controller: _message,
                    minLines: 4,
                    maxLines: 8,
                    maxLength: 2000,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: TurboSpacing.md),
                  TurboButton(
                    label: '${l10n.supportAddPhoto} · ${l10n.supportPhotos(_uploads.length)}',
                    variant: TurboButtonVariant.secondary,
                    icon: Icons.photo_camera_outlined,
                    loading: _photoBusy,
                    onPressed: _uploads.length >= 5 ? null : _addPhoto,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                      child: Semantics(liveRegion: true, child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger))),
                    ),
                  TurboButton(label: l10n.supportSend, loading: _busy, onPressed: _send),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  final _reply = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    if (_reply.text.trim().isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(clientProvider).api.getSupportApi().replyToSupportTicket(
            id: widget.ticketId,
            supportMessageCreate: SupportMessageCreate(body: _reply.text.trim()),
          );
      _reply.clear();
      ref.invalidate(ticketProvider(widget.ticketId));
    } catch (_) {
      if (mounted) setState(() => _error = l10n.supportReplyFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final ticket = ref.watch(ticketProvider(widget.ticketId));
    return Scaffold(
      appBar: AppBar(title: Text(ticket.value?.subject ?? l10n.supportTitle)),
      body: SafeArea(
        child: ticket.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(message: l10n.supportLoadFailed, onRetry: () => ref.invalidate(ticketProvider(widget.ticketId))),
          data: (tk) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(TurboSpacing.lg),
                  children: [
                    StatusChip(label: ticketStatusLabel(l10n, tk.status.value), icon: Icons.chat_bubble_outline),
                    const SizedBox(height: TurboSpacing.md),
                    for (final m in (tk.messages ?? const <SupportMessage>[]).where((m) => !(m.internal ?? false)))
                      Padding(
                        padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                        child: TurboCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.author == SupportMessageAuthorEnum.staff ? l10n.supportFromStaff : l10n.supportFromYou, style: text.labelMedium),
                              const SizedBox(height: TurboSpacing.xs),
                              Text(m.body, style: text.bodyLarge),
                              const SizedBox(height: TurboSpacing.xs),
                              Text(DateFormat('d MMM, HH:mm').format(m.createdAt.toUtc()), style: text.bodySmall),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_error != null) Padding(padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg), child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger))),
              Padding(
                padding: const EdgeInsets.all(TurboSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: TurboTextField(label: l10n.supportReplyHint, controller: _reply)),
                    const SizedBox(width: TurboSpacing.sm),
                    IconButton.filled(
                      tooltip: l10n.supportReply,
                      constraints: const BoxConstraints(minWidth: TurboSizes.primaryAction, minHeight: TurboSizes.primaryAction),
                      onPressed: _busy ? null : _send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
