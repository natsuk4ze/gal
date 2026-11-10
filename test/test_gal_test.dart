import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/testing.dart';

/// Records every call so that the tests can check what `Gal` passed.
class _FakeGal implements TestGal {
  final calls = <List<Object?>>[];

  @override
  Future<void> putVideo(String path, {String? album}) async =>
      calls.add(['putVideo', path, album]);

  @override
  Future<void> putImage(String path, {String? album}) async =>
      calls.add(['putImage', path, album]);

  @override
  Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    required String name,
  }) async => calls.add(['putImageBytes', bytes, album, name]);

  @override
  Future<void> open() async => calls.add(['open']);

  @override
  Future<bool> hasPermission({bool toAlbum = false}) async {
    calls.add(['hasPermission', toAlbum]);
    return false;
  }

  @override
  Future<bool> requestPermission({bool toAlbum = false}) async {
    calls.add(['requestPermission', toAlbum]);
    return true;
  }
}

void main() {
  late _FakeGal gal;

  setUp(() => TestGal.setUp(gal = _FakeGal()));

  test('passes the put calls with their arguments', () async {
    await Gal.putVideo('video.mp4', album: 'Album');
    await Gal.putImage('image.jpg');
    await Gal.putImageBytes(Uint8List.fromList([1, 2]), name: 'photo');

    expect(gal.calls, [
      ['putVideo', 'video.mp4', 'Album'],
      ['putImage', 'image.jpg', null],
      [
        'putImageBytes',
        [1, 2],
        null,
        'photo',
      ],
    ]);
  });

  test('passes open', () async {
    await Gal.open();

    expect(gal.calls, [
      ['open'],
    ]);
  });

  test('returns the permission results', () async {
    expect(await Gal.hasPermission(), isFalse);
    expect(await Gal.requestPermission(toAlbum: true), isTrue);

    expect(gal.calls, [
      ['hasPermission', false],
      ['requestPermission', true],
    ]);
  });
}
