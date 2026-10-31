import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/me.dart';
import '../../core/problem_messages.dart';
import '../../l10n/app_localizations.dart';
import 'draft.dart';
import 'ghana_card.dart';
import 'photo_capturer.dart';
import 'resubmit.dart';

class VerificationCaptureScreen extends ConsumerStatefulWidget {
  const VerificationCaptureScreen({super.key});

  @override
  ConsumerState<VerificationCaptureScreen> createState() => _VerificationCaptureScreenState();
}

class _VerificationCaptureScreenState extends ConsumerState<VerificationCaptureScreen> {
  final _name = TextEditingController();
  final _card = TextEditingController();
  final _studentId = TextEditingController();
  bool _touchedCard = false;
  bool _filled = false;
  bool _submitting = false;
  String? _error;
  bool _expiredNote = false;

  @override
  void initState() {
    super.initState();
    _fillFrom(ref.read(verificationProvider));
  }

  /// Puts saved details in the fields once, as soon as they are known.
  void _fillFrom(VerificationDraft d) {
    if (_filled || !d.restored) return;
    _filled = true;
    _name.text = d.fullName;
    _card.text = d.ghanaCard;
    _studentId.text = d.studentIdNumber;
  }

  @override
  void dispose() {
    _name.dispose();
    _card.dispose();
    _studentId.dispose();
    super.dispose();
  }

  Future<void> _take(DocKind kind) async {
    final bytes = await ref.read(photoCapturerProvider).capture(context, kind);
    if (bytes == null) return;
    await ref.read(verificationProvider.notifier).addPhoto(kind, bytes);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _error = null;
      _expiredNote = false;
    });
    try {
      await ref.read(verificationProvider.notifier).submit();
      await ref.read(meProvider.notifier).reload();
      ref.read(resubmitProvider.notifier).finish();
    } on ApiProblem catch (p) {
      if (!mounted) return;
      setState(() {
        _error = problemMessage(l10n, p);
        _expiredNote = p.code == ProblemCode.uploadExpired.value;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _docTitle(AppLocalizations l10n, DocKind k) => switch (k) {
        DocKind.ghanaCardFront => l10n.docGhanaCardFront,
        DocKind.ghanaCardBack => l10n.docGhanaCardBack,
        DocKind.studentId => l10n.docStudentId,
        DocKind.selfie => l10n.docSelfie,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(verificationProvider);
    _fillFrom(draft);
    final controller = ref.read(verificationProvider.notifier);
    final cardInvalid = _touchedCard && !isValidGhanaCardNumber(_card.text);

    Widget docTile(DocKind kind) {
      final doc = draft.doc(kind);
      final title = _docTitle(l10n, kind);
      final (String status, IconData icon, StatusTone tone) = switch (doc.status) {
        DocStatus.empty => (l10n.docNotTaken, Icons.photo_camera_outlined, StatusTone.neutral),
        DocStatus.uploading => (l10n.docUploading((doc.progress * 100).round()), Icons.cloud_upload_outlined, StatusTone.neutral),
        DocStatus.uploaded => (l10n.docUploaded, Icons.check_circle_outline, StatusTone.success),
        DocStatus.failed => (l10n.docFailed, Icons.error_outline, StatusTone.danger),
      };
      return Padding(
        padding: const EdgeInsets.only(bottom: TurboSpacing.md),
        child: TurboCard(
          semanticLabel: '$title, $status',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(t.radiusInput),
                    child: SizedBox.square(
                      dimension: TurboSizes.primaryAction + TurboSpacing.lg,
                      child: doc.preview != null
                          ? Image.memory(doc.preview!, fit: BoxFit.cover, excludeFromSemantics: true)
                          : ColoredBox(
                              color: t.colors.background,
                              child: Icon(Icons.badge_outlined, color: t.colors.textSecondary),
                            ),
                    ),
                  ),
                  const SizedBox(width: TurboSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: text.labelLarge),
                        const SizedBox(height: TurboSpacing.xs),
                        StatusChip(label: status, icon: icon, tone: tone),
                      ],
                    ),
                  ),
                ],
              ),
              if (doc.status == DocStatus.uploading) ...[
                const SizedBox(height: TurboSpacing.md),
                LinearProgressIndicator(
                  value: doc.progress == 0 ? null : doc.progress,
                  color: t.colors.accentText,
                  backgroundColor: t.colors.border,
                ),
              ],
              const SizedBox(height: TurboSpacing.md),
              if (doc.status == DocStatus.failed)
                TurboButton(
                  label: l10n.docRetry,
                  variant: TurboButtonVariant.secondary,
                  onPressed: () => controller.retry(kind),
                )
              else if (doc.status != DocStatus.uploading)
                TurboButton(
                  label: doc.status == DocStatus.empty ? l10n.docTake : l10n.docRetake,
                  variant: TurboButtonVariant.secondary,
                  icon: Icons.photo_camera_outlined,
                  onPressed: () => _take(kind),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TurboSpacing.xl),
                children: [
                  Semantics(header: true, child: Text(l10n.verifyTitle, style: text.headlineMedium)),
                  const SizedBox(height: TurboSpacing.md),
                  Text(l10n.verifyIntro, style: text.bodyLarge),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_outline, color: t.colors.textSecondary),
                        const SizedBox(width: TurboSpacing.md),
                        Expanded(child: Text(l10n.verifyPrivacyNote, style: text.bodyMedium)),
                      ],
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.xl),
                  TurboTextField(
                    label: l10n.verifyFullName,
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    onChanged: (v) => controller.setDetails(fullName: v),
                  ),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboTextField(
                    label: l10n.verifyGhanaCard,
                    controller: _card,
                    helper: l10n.verifyGhanaCardHelper,
                    errorText: cardInvalid ? l10n.verifyGhanaCardInvalid : null,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [GhanaCardFormatter()],
                    onChanged: (v) {
                      setState(() => _touchedCard = true);
                      controller.setDetails(ghanaCard: formatGhanaCardNumber(v));
                    },
                  ),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboTextField(
                    label: l10n.verifyStudentId,
                    controller: _studentId,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => controller.setDetails(studentIdNumber: v),
                  ),
                  const SizedBox(height: TurboSpacing.sm),
                  Text(l10n.verifyDetailsKept, style: text.bodySmall),
                  const SizedBox(height: TurboSpacing.xl),
                  Semantics(header: true, child: Text(l10n.verifyPhotosTitle, style: text.titleLarge)),
                  const SizedBox(height: TurboSpacing.md),
                  if (_expiredNote)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                      child: Text(l10n.verifyResubmitNote, style: text.bodyMedium),
                    ),
                  for (final kind in DocKind.values) docTile(kind),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(TurboSpacing.xl, TurboSpacing.sm, TurboSpacing.xl, TurboSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger)),
                      ),
                    ),
                  TurboButton(
                    label: l10n.verifySubmit,
                    large: true,
                    loading: _submitting,
                    onPressed: draft.canSubmit && !draft.anyUploading ? _submit : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
