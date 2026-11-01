import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Fails when screens or components carry raw styling. Only the brand and
/// theme layers may. This is what keeps a rebrand to one file.
void main() {
  final repoRoot = Directory.current.parent.parent;

  final patterns = <String, RegExp>{
    'colour literal': RegExp(r'Color\(\s*0x'),
    'Colors.*': RegExp(r'\bColors\.'),
    'literal font size': RegExp(r'fontSize:\s*\d'),
    'literal radius': RegExp(r'BorderRadius\.circular\(\s*\d|Radius\.circular\(\s*\d'),
    'font family': RegExp(r'fontFamily:'),
    'product name': RegExp('''['"][^'"\\n]*Turbo[^'"\\n]*['"]'''),
  };

  Iterable<File> dartFiles(String relative) {
    final dir = Directory('${repoRoot.path}/$relative');
    if (!dir.existsSync()) return const [];
    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'));
  }

  final scanned = [
    ...dartFiles('apps'),
    ...dartFiles('packages/turbo_ui/lib/src/components'),
    ...dartFiles('packages/turbo_ui/lib/src/states'),
    ...dartFiles('packages/turbo_ui/lib/src/gallery'),
  ].where((f) {
    // Only our own Dart under lib/. Platform folders (ios/.symlinks holds plugin
    // example apps), build output and tests are not app styling.
    final rel = f.path.substring(repoRoot.path.length);
    return RegExp(r'^/(apps/[^/]+|packages/turbo_ui)/lib/').hasMatch(rel);
  }).toList();

  List<String> violations(String source) {
    final found = <String>[];
    final lines = source.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trimLeft();
      if (trimmed.startsWith('//') ||
          trimmed.startsWith('import ') ||
          trimmed.startsWith('export ') ||
          trimmed.startsWith('part ')) {
        continue;
      }
      patterns.forEach((name, re) {
        if (re.hasMatch(line)) found.add('line ${i + 1}: $name');
      });
    }
    return found;
  }

  test('there are files to scan', () {
    expect(scanned, isNotEmpty);
  });

  test('no hard-coded colours, sizes, radii, fonts or product name', () {
    final report = <String>[];
    for (final file in scanned) {
      for (final v in violations(file.readAsStringSync())) {
        report.add('${file.path.replaceFirst(repoRoot.path, '')} $v');
      }
    }
    expect(report, isEmpty, reason: report.join('\n'));
  });

  test('the scanner itself catches each kind of violation', () {
    const bad = '''
final a = Color(0xFF000000);
final b = Colors.red;
final c = TextStyle(fontSize: 14);
final d = BorderRadius.circular(8);
final e = TextStyle(fontFamily: 'Roboto');
final f = Text('Welcome to Turbo');
''';
    expect(violations(bad), hasLength(6));
    expect(violations('final ok = BorderRadius.circular(t.radiusCard);'), isEmpty);
  });
}
