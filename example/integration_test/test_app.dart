import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

var logger = Logger();
bool toAlbum = false;

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: isTesting
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('toAlbum: $toAlbum'),
                      buildButton(
                        onPressed: () async => toAlbum = !toAlbum,
                        label: 'Toggle toAlbum',
                      ),
                      buildButton(
                        onPressed: () async => Gal.hasAccess(),
                        label: 'hasAccess(toAlbum: $toAlbum)',
                      ),
                      buildButton(
                        onPressed: () async => Gal.requestAccess(),
                        label: 'requestAccess(toAlbum: $toAlbum)',
                      ),
                      buildButton(
                        onPressed: () async {
                          final path = await getFilePath('assets/done.jpg');
                          await Gal.putImage(path,
                              album: toAlbum ? 'Album' : null);
                        },
                        label: 'putImage(toAlbum: $toAlbum)',
                      ),
                      buildButton(
                        onPressed: () async {
                          final byteData =
                              await rootBundle.load('assets/done.jpg');
                          final uint8List = byteData.buffer.asUint8List(
                              byteData.offsetInBytes, byteData.lengthInBytes);
                          await Gal.putImageBytes(Uint8List.fromList(uint8List),
                              album: toAlbum ? 'Album' : null);
                        },
                        label: 'putImageBytes(toAlbum: $toAlbum)',
                      ),
                      buildButton(
                        onPressed: () async {
                          final path = await getFilePath('assets/done.mp4');
                          await Gal.putVideo(path,
                              album: toAlbum ? 'Album' : null);
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

  Widget buildButton({
    required String label,
    required Future Function() onPressed,
  }) =>
      TextButton(
        key: Key(label),
        onPressed: () async {
          logger = Logger();
          setState(() => isTesting = true);
          try {
            logger.value = await onPressed();
          } catch (e, st) {
            logger.error = e;
            logger.stackTrace = e is GalException ? e.stackTrace : st;
            if (e is GalException) {
              logger.platformException = e.error as PlatformException;
            }
          } finally {
            setState(() => isTesting = false);
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
}

class Logger {
  dynamic value;
  Object? error;
  StackTrace? stackTrace;
  PlatformException? platformException;
}
