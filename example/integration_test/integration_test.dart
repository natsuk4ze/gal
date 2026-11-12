import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

/// Integration_test is required to test native code,
/// but it is not necessary to build the widget.
void main() {
  group('throws', () {
    // [0, 0, 1, 1] looks like a 1x1 WBMP, which has no signature.
    for (final bytes in [
      [0, 1, 2, 3],
      [0, 0, 1, 1],
    ]) {
      testThrows(
        'putImageBytes($bytes)',
        () => Gal.putImageBytes(Uint8List.fromList(bytes)),
        GalExceptionType.notSupportedFormat,
        skip: Platform.isMacOS,
      );
    }
    testThrows(
      'putImage(missing file)',
      () => Gal.putImage('/no/such/file.jpg'),
      GalExceptionType.unexpected,
      skip: Platform.isMacOS,
    );
  });

  // This group runs last, because Gal.open at its end opens the gallery app
  // over this app.
  group('completes', () {
    for (final album in ['album', null]) {
      final toAlbum = album != null;
      testCompletes(
        'hasPermission(toAlbum: $toAlbum)',
        () => Gal.hasPermission(toAlbum: toAlbum),
      );
      testCompletes(
        'requestPermission(toAlbum: $toAlbum)',
        () => Gal.requestPermission(toAlbum: toAlbum),
        skip: Platform.isMacOS,
      );
      testCompletes(
        'putImage(album: $album)',
        () async => Gal.putImage(await copyAsset('done.jpg'), album: album),
        skip: Platform.isMacOS,
      );
      testCompletes(
        'putImageBytes(album: $album)',
        () async =>
            Gal.putImageBytes(await loadAsset('done.jpg'), album: album),
        skip: Platform.isMacOS,
      );
      testCompletes(
        'putImageBytes(webp, album: $album)',
        () async =>
            Gal.putImageBytes(await loadAsset('done.webp'), album: album),
        skip: !Platform.isAndroid,
      );
      testCompletes(
        'putVideo(album: $album)',
        () async => Gal.putVideo(await copyAsset('done.mp4'), album: album),
        skip: Platform.isMacOS,
      );
    }
    testCompletes('open', Gal.open);
  });
}

/// Fails with the native stack trace too, if [body] throws a [GalException].
void testCompletes(
  String description,
  Future<Object?> Function() body, {
  bool skip = false,
}) => test(description, () async {
  try {
    final value = await body();
    if (value != null) debugPrint('returned: $value');
  } on GalException catch (e) {
    fail('$e\n${e.platformException.details ?? ''}');
  }
}, skip: skip);

/// Expects [body] to throw a [GalException] of [type].
void testThrows(
  String description,
  Future<void> Function() body,
  GalExceptionType type, {
  bool skip = false,
}) => test(
  description,
  () => expectLater(
    body(),
    throwsA(isA<GalException>().having((e) => e.type, 'type', type)),
  ),
  skip: skip,
);

Future<Uint8List> loadAsset(String name) async {
  final data = await rootBundle.load('assets/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

/// Copies the asset to a file, because the put methods take a file path.
Future<String> copyAsset(String name) async {
  final file = File('${Directory.systemTemp.path}/$name');
  await file.writeAsBytes(await loadAsset(name));
  return file.path;
}
