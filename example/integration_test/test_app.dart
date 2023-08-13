import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

var logger = Logger();
bool toAlbum = false;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(
                  onPressed: () async => toAlbum = !toAlbum,
                  label: 'Toggle toAlbum',
                ),
                buildButton(
                  onPressed: () async => Gal.hasAccess(toAlbum: toAlbum),
                  label: 'hasAccess(toAlbum: $toAlbum)',
                ),
                buildButton(
                  onPressed: () async => Gal.requestAccess(toAlbum: toAlbum),
                  label: 'requestAccess(toAlbum: $toAlbum)',
                ),
                buildButton(
                  onPressed: () async {
                    final path = await getFilePath('assets/done.jpg');
                    await Gal.putImage(path, album: album);
                  },
                  label: 'putImage(toAlbum: $toAlbum)',
                ),
                buildButton(
                  onPressed: () async {
                    final bytes = await getBytesData('assets/done.jpg');
                    await Gal.putImageBytes(bytes, album: album);
                  },
                  label: 'putImageBytes(toAlbum: $toAlbum)',
                ),
                buildButton(
                  onPressed: () async {
                    final path = await getFilePath('assets/done.mp4');
                    await Gal.putVideo(path, album: album);
                  },
                  label: 'putVideo(toAlbum: $toAlbum)',
                ),
                buildButton(
                  onPressed: () async => Gal.open(),
                  label: 'open()',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? get album => toAlbum ? 'Album' : null;

  Widget buildButton({
    required String label,
    required Future Function() onPressed,
  }) =>
      TextButton(
        key: Key(label),
        onPressed: () async {
          logger = Logger();
          try {
            logger.value = await onPressed();
          } catch (e, st) {
            logger.error = e;
            logger.stackTrace = e is GalException ? e.stackTrace : st;
            if (e is GalException) {
              logger.platformException = e.error as PlatformException;
            }
          }
        },
        child: Text(label),
      );

  Future<String> getFilePath(String path) async {
    final byteData = await rootBundle.load(path);
    final file = await File(
            '${Directory.systemTemp.path}${path.replaceAll('assets', '')}')
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
}

class Logger {
  dynamic value;
  Object? error;
  StackTrace? stackTrace;
  PlatformException? platformException;
}
