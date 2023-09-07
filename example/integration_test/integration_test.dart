import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

Future<void> main() async {
  for (var i = 0; i < 2; i++) {
    final toAlbum = i == 0 ? false : true;
    final album = toAlbum ? 'Album' : null;

    await run('hasAccess(toAlbum: $toAlbum)',
        () async => Gal.hasAccess(toAlbum: toAlbum));

    await run('requestAccess(toAlbum: $toAlbum)',
        () async => Gal.requestAccess(toAlbum: toAlbum),
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

Future<void> run(String title, Future<dynamic> Function() function) async =>
    test(
      title,
      () async {
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
