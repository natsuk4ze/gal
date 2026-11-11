import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/testing.dart';

/// Records the name of every method that `Gal` calls.
class _FakeGal implements TestGal {
  final calls = <Symbol>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation.memberName);
    return Future.value(true);
  }
}

void main() {
  test('Gal calls every method of the TestGal that is set up', () async {
    final gal = _FakeGal();
    TestGal.setUp(gal);

    await Gal.putVideo('');
    await Gal.putImage('');
    await Gal.putImageBytes(Uint8List(0));
    await Gal.open();
    await Gal.hasPermission();
    await Gal.requestPermission();

    expect(gal.calls, [
      #putVideo,
      #putImage,
      #putImageBytes,
      #open,
      #hasPermission,
      #requestPermission,
    ]);
  });
}
