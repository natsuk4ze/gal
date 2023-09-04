import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

void main() {
  for (var i = 0; i < 2; i++) {
    final toAlbum = i == 1 ? true : false;
    final album = toAlbum ? 'Album' : null;

    run('hasAccess(toAlbum: $toAlbum)',
        () async => Gal.hasAccess(toAlbum: toAlbum));

    run('requestAccess(toAlbum: $toAlbum)',
        () async => Gal.requestAccess(toAlbum: toAlbum));

    run('putImage(album: $album)', () async {
      final path = await getFilePath('assets/done.jpg');
      await Gal.putImage(path, album: album);
    });

    run('putImageBytes(album: $album)', () async {
      final bytes = await getBytesData('assets/done.jpg');
      await Gal.putImageBytes(bytes, album: album);
    });

    run('putVideo(album: $album)', () async {
      final path = await getFilePath('assets/done.mp4');
      await Gal.putVideo(path, album: album);
    });
  }
  run('open', () async => Gal.open());
}

void run(String title, Future<dynamic> Function() function) =>
    test(title, () async {
      var logger = Logger();
      try {
        logger.value = await function();
      } catch (e, st) {
        logger.error = e;
        logger.stackTrace = e is GalException ? e.stackTrace : st;
        if (e is GalException) {
          logger.platformException = e.error as PlatformException;
        }
      }
      final value = logger.value;
      if (value != null) debugPrint('returned: $value');

      if (logger.error == null) return;
      fail("""
${logger.error.runtimeType}: ${logger.error}\n
StackTrace: ${logger.stackTrace}
PlatformException: ${logger.platformException}""");
    });

class Logger {
  dynamic value;
  Object? error;
  StackTrace? stackTrace;
  PlatformException? platformException;
}

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
