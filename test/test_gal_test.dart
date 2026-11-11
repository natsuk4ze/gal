import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/testing.dart';

class _FakeGal extends Fake implements TestGal {
  String? path;

  @override
  Future<void> putImage(String path, {String? album}) async => this.path = path;
}

void main() {
  test('Gal calls the TestGal that is set up', () async {
    final gal = _FakeGal();
    TestGal.setUp(gal);

    await Gal.putImage('image.jpg');

    expect(gal.path, 'image.jpg');
  });
}
