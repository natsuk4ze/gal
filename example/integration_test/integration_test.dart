import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

const images = ['jpg', 'png', 'gif', 'bmp', 'tiff', 'heic', 'avif', 'webp'];
const videos = ['mp4', 'mov', 'webm'];

/// The images whose format [Gal.putImageBytes] detects from the bytes.
final detectedImages = Platform.isWindows
    ? ['jpg', 'png', 'gif', 'bmp', 'tiff']
    : Platform.isAndroid
    ? [
        'jpg',
        'png',
        'gif',
        'bmp',
        'webp',
        if (androidSdk >= 28) 'heic',
        if (androidSdk >= 31) 'avif',
      ]
    : images;

/// Photos does not support WebM.
final savedVideos = Platform.isIOS || Platform.isMacOS
    ? ['mp4', 'mov']
    : videos;

final androidSdk = int.parse(
  '${Process.runSync('getprop', ['ro.build.version.sdk']).stdout}'.trim(),
);

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
      );
    }
    for (final type in images.where((e) => !detectedImages.contains(e))) {
      testThrows(
        'putImageBytes($type)',
        () async => Gal.putImageBytes(await loadAsset('done.$type')),
        GalExceptionType.notSupportedFormat,
      );
    }
    for (final type in videos.where((e) => !savedVideos.contains(e))) {
      testThrows(
        'putVideo($type)',
        () async => Gal.putVideo(await copyAsset('done.$type')),
        GalExceptionType.notSupportedFormat,
      );
    }
    testThrows(
      'putImage(missing file)',
      () => Gal.putImage('/no/such/file.jpg'),
      GalExceptionType.unexpected,
    );
  });

  // Runs last, as Gal.open opens the gallery app over this app.
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
      );
      for (final type in images) {
        testCompletes(
          'putImage($type, album: $album)',
          () async => Gal.putImage(await copyAsset('done.$type'), album: album),
        );
      }
      for (final type in detectedImages) {
        testCompletes(
          'putImageBytes($type, album: $album)',
          () async =>
              Gal.putImageBytes(await loadAsset('done.$type'), album: album),
        );
      }
      for (final type in savedVideos) {
        testCompletes(
          'putVideo($type, album: $album)',
          () async => Gal.putVideo(await copyAsset('done.$type'), album: album),
        );
      }
    }
    testCompletes('open', Gal.open);
  });
}

/// Fails with the native stack trace too, if [body] throws a [GalException].
void testCompletes(String description, Future<Object?> Function() body) =>
    test(description, () async {
      try {
        final value = await body();
        if (value != null) debugPrint('returned: $value');
      } on GalException catch (e) {
        fail('$e\n${e.platformException.details ?? ''}');
      }
    });

void testThrows(
  String description,
  Future<void> Function() body,
  GalExceptionType type,
) => test(
  description,
  () => expectLater(
    body(),
    throwsA(isA<GalException>().having((e) => e.type, 'type', type)),
  ),
);

Future<Uint8List> loadAsset(String name) async {
  final data = await rootBundle.load('assets/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<String> copyAsset(String name) async {
  final file = File('${Directory.systemTemp.path}/$name');
  await file.writeAsBytes(await loadAsset(name));
  return file.path;
}
