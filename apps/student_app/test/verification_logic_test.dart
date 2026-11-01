import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:student_app/src/features/verification/ghana_card.dart';
import 'package:student_app/src/features/verification/image_quality.dart';

Uint8List png(img.Image image) => Uint8List.fromList(img.encodePng(image));

/// A busy, high-contrast picture: plenty of sharp edges.
img.Image sharp() {
  final image = img.Image(width: 480, height: 300);
  for (var y = 0; y < 300; y++) {
    for (var x = 0; x < 480; x++) {
      final on = ((x ~/ 6) + (y ~/ 6)) % 2 == 0;
      final v = on ? 190 : 70;
      image.setPixelRgb(x, y, v, v, v);
    }
  }
  return image;
}

void main() {
  group('image quality', () {
    test('a sharp, well-lit photo passes', () {
      final r = analyseQuality(png(sharp()));
      expect(r.issues, isEmpty, reason: 'sharpness ${r.sharpness}, brightness ${r.brightness}');
    });

    test('a blurred photo is flagged as blurry', () {
      final r = analyseQuality(png(img.gaussianBlur(sharp(), radius: 12)));
      expect(r.issues, contains(QualityIssue.blurry));
    });

    test('a photo with a large white reflection is flagged as glare', () {
      final image = sharp();
      img.fillRect(image, x1: 0, y1: 0, x2: 200, y2: 150, color: img.ColorRgb8(255, 255, 255));
      expect(analyseQuality(png(image)).issues, contains(QualityIssue.glare));
    });

    test('a dark photo is flagged as too dark', () {
      final image = img.Image(width: 480, height: 300);
      for (var y = 0; y < 300; y++) {
        for (var x = 0; x < 480; x++) {
          final v = ((x ~/ 6) + (y ~/ 6)) % 2 == 0 ? 30 : 5;
          image.setPixelRgb(x, y, v, v, v);
        }
      }
      expect(analyseQuality(png(image)).issues, contains(QualityIssue.tooDark));
    });

    test('bytes that are not an image are unreadable', () {
      expect(analyseQuality(Uint8List.fromList([1, 2, 3])).issues, {QualityIssue.unreadable});
    });

    test('compression keeps the long side under the limit', () async {
      final big = img.Image(width: 3200, height: 2000);
      final out = await compressForUpload(png(big), maxSide: 1600);
      final decoded = img.decodeJpg(out)!;
      expect(decoded.width, 1600);
      expect(decoded.height, 1000);
    });
  });

  group('Ghana Card number', () {
    test('validates the contract pattern', () {
      expect(isValidGhanaCardNumber('GHA-123456789-0'), isTrue);
      expect(isValidGhanaCardNumber('GHA-12345678-0'), isFalse);
      expect(isValidGhanaCardNumber('gha-123456789-0'), isFalse);
      expect(isValidGhanaCardNumber('123456789-0'), isFalse);
    });

    test('formats typing, pasting and lower case', () {
      expect(formatGhanaCardNumber('1'), 'GHA-1');
      expect(formatGhanaCardNumber('123456789'), 'GHA-123456789');
      expect(formatGhanaCardNumber('1234567890'), 'GHA-123456789-0');
      expect(formatGhanaCardNumber('gha1234567890'), 'GHA-123456789-0');
      expect(formatGhanaCardNumber('GHA-123456789-0'), 'GHA-123456789-0');
      expect(formatGhanaCardNumber('123456789012345'), 'GHA-123456789-0', reason: 'extra digits are ignored');
    });
  });
}
