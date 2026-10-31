import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'draft.dart';
import 'image_quality.dart';

/// Takes one photo of a document and returns its bytes, or null if cancelled.
/// Behind an interface so tests never need a camera.
abstract class PhotoCapturer {
  Future<Uint8List?> capture(BuildContext context, DocKind kind);
}

class CameraPhotoCapturer implements PhotoCapturer {
  const CameraPhotoCapturer();

  @override
  Future<Uint8List?> capture(BuildContext context, DocKind kind) => Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(fullscreenDialog: true, builder: (_) => CameraCaptureScreen(kind: kind)),
      );
}

final photoCapturerProvider = Provider<PhotoCapturer>((_) => const CameraPhotoCapturer());

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key, required this.kind});

  final DocKind kind;

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

enum _Phase { starting, ready, denied, failed, review }

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  _Phase _phase = _Phase.starting;
  Uint8List? _shot;
  QualityReport? _report;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      final cameras = await availableCameras();
      final wanted = widget.kind == DocKind.selfie ? CameraLensDirection.front : CameraLensDirection.back;
      final camera = cameras.firstWhere((c) => c.lensDirection == wanted, orElse: () => cameras.first);
      final controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _phase = _Phase.ready;
      });
    } on CameraException catch (e) {
      if (mounted) setState(() => _phase = e.code.contains('Denied') ? _Phase.denied : _Phase.failed);
    } catch (_) {
      if (mounted) setState(() => _phase = _Phase.failed);
    }
  }

  Future<void> _shutter() async {
    final controller = _controller;
    if (controller == null || _busy) return;
    setState(() => _busy = true);
    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      final report = await compute(analyseQuality, bytes);
      if (mounted) {
        setState(() {
          _shot = bytes;
          _report = report;
          _phase = _Phase.review;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _phase = _Phase.failed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _issueText(AppLocalizations l10n, QualityIssue i) => switch (i) {
        QualityIssue.blurry => l10n.captureIssueBlurry,
        QualityIssue.glare => l10n.captureIssueGlare,
        QualityIssue.tooDark => l10n.captureIssueDark,
        QualityIssue.unreadable => l10n.captureIssueUnreadable,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final selfie = widget.kind == DocKind.selfie;

    Widget message(String body, {Widget? action}) => Center(
          child: Padding(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(body, style: text.bodyLarge, textAlign: TextAlign.center),
                if (action != null) ...[const SizedBox(height: TurboSpacing.xl), action],
              ],
            ),
          ),
        );

    final Widget body = switch (_phase) {
      _Phase.starting => const LoadingState(rows: 1),
      _Phase.denied => message(
          l10n.captureCameraDenied(t.brand.appName),
          action: TurboButton(
            label: l10n.captureOpenSettings,
            expand: false,
            onPressed: () => launchUrl(Uri.parse('app-settings:')),
          ),
        ),
      _Phase.failed => message(
          l10n.captureCameraFailed,
          action: TurboButton(
            label: l10n.tryAgain,
            expand: false,
            onPressed: () {
              setState(() => _phase = _Phase.starting);
              _start();
            },
          ),
        ),
      _Phase.ready => Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(child: CameraPreview(_controller!)),
                  IgnorePointer(child: CustomPaint(painter: _FramePainter(color: t.colors.accent, shade: t.colors.background.withValues(alpha: 0.6), round: selfie, radius: t.radiusCard))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selfie ? l10n.captureGuideSelfie : l10n.captureGuideCard, style: text.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: TurboSpacing.md),
                  TurboButton(label: l10n.captureShutter, large: true, loading: _busy, onPressed: _shutter),
                ],
              ),
            ),
          ],
        ),
      _Phase.review => Column(
          children: [
            Expanded(child: Image.memory(_shot!, fit: BoxFit.contain, semanticLabel: '')),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_report!.ok)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: t.colors.success),
                        const SizedBox(width: TurboSpacing.sm),
                        Text(l10n.captureLooksGood, style: text.bodyMedium),
                      ],
                    )
                  else
                    for (final issue in _report!.issues)
                      Padding(
                        padding: const EdgeInsets.only(bottom: TurboSpacing.xs),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber, color: t.colors.warning),
                            const SizedBox(width: TurboSpacing.sm),
                            Expanded(child: Text(_issueText(l10n, issue), style: text.bodyMedium)),
                          ],
                        ),
                      ),
                  const SizedBox(height: TurboSpacing.md),
                  // A flagged photo leads with Retake; the person can still use it.
                  TurboButton(
                    label: l10n.docRetake,
                    variant: _report!.ok ? TurboButtonVariant.secondary : TurboButtonVariant.primary,
                    onPressed: () => setState(() {
                      _shot = null;
                      _phase = _Phase.ready;
                    }),
                  ),
                  const SizedBox(height: TurboSpacing.sm),
                  TurboButton(
                    label: l10n.captureUsePhoto,
                    variant: _report!.ok ? TurboButtonVariant.primary : TurboButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(_shot),
                  ),
                ],
              ),
            ),
          ],
        ),
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.captureCancel,
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}

/// Dims everything outside a card-shaped (or oval, for selfies) window.
class _FramePainter extends CustomPainter {
  _FramePainter({required this.color, required this.shade, required this.round, required this.radius});

  final Color color;
  final Color shade;
  final bool round;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.86;
    final h = round ? w * 1.1 : w * 0.63; // ID-1 card ratio
    final rect = Rect.fromCenter(center: size.center(Offset.zero), width: w, height: h);
    final window = round ? RRect.fromRectAndRadius(rect, Radius.circular(w / 2)) : RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final outside = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(window)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(outside, Paint()..color = shade);
    canvas.drawRRect(window, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = color);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.color != color || old.shade != shade || old.round != round || old.radius != radius;
}
