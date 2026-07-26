import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

/// Integration_test is required to test native code,
/// but it is not necessary to build the widget.
Future<void> main() async {
  final testCases = [
    for (final isSavedToAlbum in [true, false])
      TestCase(isSavedToAlbum: isSavedToAlbum),
  ];

  for (final testCase in testCases) {
    final toAlbum = testCase.toAlbum;
    final album = testCase.album;

    await run('hasPermission(toAlbum: $toAlbum)',
        () async => Gal.hasPermission(toAlbum: toAlbum));

    await run('requestPermission(toAlbum: $toAlbum)',
        () async => Gal.requestPermission(toAlbum: toAlbum),
        skip: Platform.isMacOS);

    await run('putImage(album: $album)', () async {
      final path = await getFilePath('assets/done.jpg');
      await Gal.putImage(path, album: album);
    }, skip: Platform.isMacOS);

    await run('putImageBytes(album: $album)', () async {
      final bytes = await getBytesData('assets/done.jpg');
      await Gal.putImageBytes(bytes, album: album);
    }, skip: Platform.isMacOS);

    await run('putVideo(album: $album)', () async {
      final path = await getFilePath('assets/done.mp4');
      await Gal.putVideo(path, album: album);
    }, skip: Platform.isMacOS);
  }
  await run('open', () async => Gal.open());
}

Future<void> run(
  String title,
  Future<dynamic> Function() function, {
  bool skip = false,
}) async =>
    test(title, () async {
      try {
        final value = await function();
        if (value != null) debugPrint('returned: $value');
      } on GalException catch (e, st) {
        fail("""
${e.runtimeType}: $e\n
StackTrace: $st
PlatformException: ${e.platformException}""");
      }
    }, skip: skip);

Future<String> getFilePath(String path) async {
  final byteData = await rootBundle.load(path);
  final file =
      await File('${Directory.systemTemp.path}${path.replaceAll('assets', '')}')
          .create();
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file.path;
}

Future<Uint8List> getBytesData(String path) async {
  final byteData = await rootBundle.load(path);
  final uint8List = byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  return Uint8List.fromList(uint8List);
}

class TestCase {
  const TestCase({required this.isSavedToAlbum});
  final bool isSavedToAlbum;

  bool get toAlbum => isSavedToAlbum;
  String? get album => isSavedToAlbum ? 'album' : null;
}
