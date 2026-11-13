import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

typedef Support = ({bool android, bool apple, bool windows});

/// The image types that each platform supports.
/// Windows supports the types that it detects from the bytes.
const images = <String, Support>{
  'jpg': (android: true, apple: true, windows: true),
  'png': (android: true, apple: true, windows: true),
  'gif': (android: true, apple: true, windows: true),
  'bmp': (android: true, apple: true, windows: true),
  'webp': (android: true, apple: true, windows: false),
  'heic': (android: true, apple: true, windows: false),
  'heif': (android: true, apple: true, windows: false),
  'avif': (android: true, apple: true, windows: false),
  'tiff': (android: false, apple: true, windows: true),
  'dng': (android: true, apple: true, windows: true),
  'emf': (android: false, apple: false, windows: true),
};

/// The video types that each platform supports.
const videos = <String, Support>{
  'mp4': (android: true, apple: true, windows: true),
  'mov': (android: false, apple: true, windows: true),
  'm4v': (android: false, apple: true, windows: true),
  'avi': (android: false, apple: true, windows: true),
  '3gp': (android: true, apple: true, windows: true),
  'ts': (android: true, apple: false, windows: true),
  'mkv': (android: true, apple: false, windows: true),
  'webm': (android: true, apple: false, windows: true),
};

/// The Android API level that each type is supported from.
const androidApi = {'heic': 28, 'heif': 28, 'avif': 31};

final android = Platform.isAndroid;
final apple = Platform.isIOS || Platform.isMacOS;

/// The Android API level, or 0 on the other platforms.
final api = android
    ? int.parse(
        '${Process.runSync('getprop', ['ro.build.version.sdk']).stdout}'.trim(),
      )
    : 0;

bool isSupported(String type, Support support) => android
    ? support.android && api >= (androidApi[type] ?? 0)
    : apple
    ? support.apple
    : support.windows;

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
    testThrows(
      'putImage(missing file)',
      () => Gal.putImage('/no/such/file.jpg'),
      GalExceptionType.unexpected,
    );
  });

  for (final album in ['album', null]) {
    group('album: $album', () {
      final toAlbum = album != null;
      testCompletes(
        'hasPermission(toAlbum: $toAlbum)',
        () => Gal.hasPermission(toAlbum: toAlbum),
      );
      testCompletes(
        'requestPermission(toAlbum: $toAlbum)',
        () => Gal.requestPermission(toAlbum: toAlbum),
      );
      for (final MapEntry(key: type, value: support) in images.entries) {
        final supported = isSupported(type, support);
        testPut(
          'putImage($type)',
          () async => Gal.putImage(await copyAsset('done.$type'), album: album),
          supported: supported,
          checksType: apple,
        );
        testPut(
          'putImageBytes($type)',
          () async =>
              Gal.putImageBytes(await loadAsset('done.$type'), album: album),
          supported: supported,
          checksType: true,
        );
      }
      for (final MapEntry(key: type, value: support) in videos.entries) {
        testPut(
          'putVideo($type)',
          () async => Gal.putVideo(await copyAsset('done.$type'), album: album),
          supported: isSupported(type, support),
          checksType: apple,
        );
      }
    });
  }

  // Runs last, as it opens the gallery app over this app.
  testCompletes('open', Gal.open);
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

/// Expects [body] to save a supported type, and to throw `notSupportedFormat`
/// for an unsupported one if the method [checksType] on this platform.
/// Otherwise the file is saved as is, or the OS may refuse it.
void testPut(
  String description,
  Future<void> Function() body, {
  required bool supported,
  required bool checksType,
}) {
  if (supported) return testCompletes(description, body);
  if (checksType) {
    return testThrows(description, body, GalExceptionType.notSupportedFormat);
  }
  test(description, () {}, skip: 'Not supported, and not checked');
}

Future<Uint8List> loadAsset(String name) async {
  final data = await rootBundle.load('assets/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<String> copyAsset(String name) async {
  final file = File('${Directory.systemTemp.path}/$name');
  await file.writeAsBytes(await loadAsset(name));
  return file.path;
}
