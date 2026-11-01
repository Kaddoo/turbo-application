import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Problems we can spot on the phone before upload. A clean result does not
/// guarantee the reviewer can read the card; a flagged one is a prompt to retake.
enum QualityIssue { blurry, glare, tooDark, unreadable }

@immutable
class QualityReport {
  const QualityReport(this.issues, {this.sharpness = 0, this.glareShare = 0, this.brightness = 0});

  final Set<QualityIssue> issues;
  final double sharpness;
  final double glareShare;
  final double brightness;

  bool get ok => issues.isEmpty;
}

/// Tunable limits, measured on a 480 px wide grayscale copy.
class QualityLimits {
  const QualityLimits({this.minSharpness = 40, this.maxGlareShare = 0.05, this.minBrightness = 45});

  /// Variance of the Laplacian. Low means few sharp edges, so blur.
  final double minSharpness;

  /// Share of near-white pixels that makes a reflection likely.
  final double maxGlareShare;

  /// Mean brightness (0 to 255) under which the photo is too dark.
  final double minBrightness;
}

QualityReport analyseQuality(Uint8List jpegOrPng, {QualityLimits limits = const QualityLimits()}) {
  final decoded = img.decodeImage(jpegOrPng);
  if (decoded == null) return const QualityReport({QualityIssue.unreadable});

  final small = decoded.width > 480 ? img.copyResize(decoded, width: 480) : decoded;
  final gray = img.grayscale(small);
  final w = gray.width, h = gray.height;

  double lum(int x, int y) => gray.getPixel(x, y).r.toDouble();

  var sum = 0.0, bright = 0, total = 0;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final l = lum(x, y);
      sum += l;
      if (l >= 250) bright++;
      total++;
    }
  }
  final mean = sum / total;

  // Variance of the 4-neighbour Laplacian.
  var lapSum = 0.0, lapSq = 0.0, n = 0;
  for (var y = 1; y < h - 1; y++) {
    for (var x = 1; x < w - 1; x++) {
      final v = 4 * lum(x, y) - lum(x - 1, y) - lum(x + 1, y) - lum(x, y - 1) - lum(x, y + 1);
      lapSum += v;
      lapSq += v * v;
      n++;
    }
  }
  final mean2 = n == 0 ? 0 : lapSum / n;
  final variance = n == 0 ? 0.0 : math.max(0.0, lapSq / n - mean2 * mean2);

  final share = bright / total;
  final issues = <QualityIssue>{
    if (variance < limits.minSharpness) QualityIssue.blurry,
    if (share > limits.maxGlareShare) QualityIssue.glare,
    if (mean < limits.minBrightness) QualityIssue.tooDark,
  };
  return QualityReport(issues, sharpness: variance, glareShare: share, brightness: mean);
}

/// Shrinks a photo to at most [maxSide] px and re-encodes as JPEG, so uploads
/// stay small on a poor connection. Runs on a background isolate.
Future<Uint8List> compressForUpload(Uint8List bytes, {int maxSide = 1600, int quality = 82}) =>
    compute(_compress, (bytes, maxSide, quality));

Uint8List _compress((Uint8List, int, int) args) {
  final (bytes, maxSide, quality) = args;
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;
  final longest = math.max(decoded.width, decoded.height);
  final resized = longest > maxSide
      ? (decoded.width >= decoded.height
          ? img.copyResize(decoded, width: maxSide)
          : img.copyResize(decoded, height: maxSide))
      : decoded;
  return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
}
