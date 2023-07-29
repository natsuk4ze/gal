import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

var logger = Logger();

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      buildButton(
                        onPressed: () async => Gal.hasAccess(),
                        label: 'hasAccess()',
                      ),
                      buildButton(
                        onPressed: () async => Gal.requestAccess(),
                        label: 'requestAccess()',
                      ),
                      buildButton(
                        onPressed: () async {
                          final path = await getFilePath('assets/done.jpg');
                          await Gal.putImage(path);
                        },
                        label: 'putImage()',
                      ),
                      buildButton(
                        onPressed: () async {
                          final byteData =
                              await rootBundle.load('assets/done.jpg');
                          final uint8List = byteData.buffer.asUint8List(
                              byteData.offsetInBytes, byteData.lengthInBytes);
                          await Gal.putImageBytes(
                              Uint8List.fromList(uint8List));
                        },
                        label: 'putImageBytes()',
                      ),
                      buildButton(
                        onPressed: () async {
                          final path = await getFilePath('assets/done.mp4');
                          await Gal.putVideo(path);
                        },
                        label: 'putVideo()',
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
          setState(() => isLoading = true);
          try {
            await onPressed();
          } catch (e, st) {
            logger.error = e;
            logger.stackTrace = st;
          } finally {
            setState(() => isLoading = false);
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
  Object? error;
  StackTrace? stackTrace;
}
