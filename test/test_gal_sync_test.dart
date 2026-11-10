import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The methods that [className] declares in [path], without default values.
Set<String> _methods(String path, String className) {
  final source = File(path).readAsStringSync();
  final start = source.indexOf(RegExp('class $className\\b'));
  final body = source.substring(start, source.indexOf('\n}', start));
  return {
    for (final m in RegExp(r'Future<\w+> (\w+)\(([^)]*)\)').allMatches(body))
      '${m[1]}(${_normalize(m[2]!)})',
  };
}

/// Drops default values, line breaks and commas from [parameters].
String _normalize(String parameters) => parameters
    .replaceAll(RegExp(r' = [^,}]+'), '')
    .replaceAll(RegExp(r'[\s,]+'), ' ')
    .trim();

void main() {
  // The adapter inherits the default bodies of GalPlatform, so the compiler
  // does not notice when TestGal misses a method or a parameter.
  test('TestGal has the same methods as GalPlatform', () {
    final platform = _methods(
      'lib/src/gal_platform_interface.dart',
      'GalPlatform',
    );

    expect(_methods('lib/src/test_gal.dart', 'TestGal'), platform);
    expect(_methods('lib/src/test_gal.dart', '_TestGalAdapter'), platform);
  });
}
