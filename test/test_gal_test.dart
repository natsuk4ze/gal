import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/testing.dart';

/// Answers every call, so that no call reaches the native code.
class _FakeGal implements TestGal {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future.value(true);
}

void main() {
  setUp(() => TestGal.setUp(_FakeGal()));

  test('putVideo', () => Gal.putVideo(''));
  test('putImage', () => Gal.putImage(''));
  test('putImageBytes', () => Gal.putImageBytes(Uint8List(0)));
  test('open', Gal.open);
  test('hasPermission', Gal.hasPermission);
  test('requestPermission', Gal.requestPermission);
}
