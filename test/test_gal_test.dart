import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/testing.dart';

/// Throws the name of the method that `Gal` calls.
class _FakeGal implements TestGal {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw invocation.memberName;
}

void main() {
  setUp(() => TestGal.setUp(_FakeGal()));

  test('Gal calls every method of the TestGal that is set up', () async {
    await expectLater(Gal.putVideo(''), throwsA(#putVideo));
    await expectLater(Gal.putImage(''), throwsA(#putImage));
    await expectLater(Gal.putImageBytes(Uint8List(0)), throwsA(#putImageBytes));
    await expectLater(Gal.open(), throwsA(#open));
    await expectLater(Gal.hasPermission(), throwsA(#hasPermission));
    await expectLater(Gal.requestPermission(), throwsA(#requestPermission));
  });
}
