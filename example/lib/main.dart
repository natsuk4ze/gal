import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gal/gal.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Saved! ✅'),
      action: SnackBarAction(
        label: 'Gallery ->',
        onPressed: () async => Gal.open(),
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        body: Builder(builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Button(
                    onPressed: () async {
                      final requestGranted = await Gal.requestAccess();
                      if (requestGranted) {
                        final path = await getFilePath('assets/done.jpg');
                        try {
                          await Gal.putImage(path);
                        } on GalException catch (e) {
                          log(e.toString());
                        }
                        return;
                      }
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Unable to save"),
                          content: const Text(
                              "Please allow access to the Photos app."),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    label: 'Best Practice',
                  ),
                  _Button(
                    onPressed: () async => Gal.open(),
                    label: 'Open Gallery',
                  ),
                  _Button(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.mp4');
                      await Gal.putVideo(path);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    label: 'Save Video from local',
                  ),
                  _Button(
                    onPressed: () async {
                      final path = '${Directory.systemTemp.path}/done.mp4';
                      await Dio().download(
                        'https://github.com/natsuk4ze/gal/raw/main/example/assets/done.mp4',
                        path,
                      );
                      await Gal.putVideo(path);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    label: 'Download Video',
                  ),
                  _Button(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.jpg');
                      await Gal.putImage(path);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    label: 'Save Image from local',
                  ),
                  _Button(
                    onPressed: () async {
                      final byteData = await rootBundle.load('assets/done.jpg');
                      final uint8List = byteData.buffer.asUint8List(
                          byteData.offsetInBytes, byteData.lengthInBytes);
                      await Gal.putImageBytes(Uint8List.fromList(uint8List));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    label: 'Save Image from bytes',
                  ),
                  _Button(
                    onPressed: () async {
                      final path = '${Directory.systemTemp.path}/done.jpg';
                      await Dio().download(
                        'https://github.com/natsuk4ze/gal/raw/main/example/assets/done.jpg',
                        path,
                      );
                      await Gal.putImage(path);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    label: 'Download Image',
                  ),
                  _Button(
                    onPressed: () async {
                      final hasAccess = await Gal.hasAccess();
                      log('Has Access:${hasAccess.toString()}');
                    },
                    label: 'Has Access',
                  ),
                  _Button(
                    onPressed: () async {
                      final requestGranted = await Gal.requestAccess();
                      log('Request Granted:${requestGranted.toString()}');
                    },
                    label: 'Request Access',
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

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

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text(label),
      ),
    );
  }
}
