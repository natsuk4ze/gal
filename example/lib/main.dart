import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gal/gal.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool toAlbum = false;
  @override
  Widget build(BuildContext context) {
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
                  const Text('toAlbum'),
                  Switch(
                      value: toAlbum,
                      onChanged: (_) => setState(() => toAlbum = !toAlbum)),
                  FilledButton(
                    onPressed: () async {
                      final requestGranted =
                          await Gal.requestAccess(toAlbum: toAlbum);
                      if (requestGranted) {
                        final path = await getFilePath('assets/done.jpg');
                        try {
                          await Gal.putImage(path, album: album);

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    child: const Text('Best Practice'),
                  ),
                  FilledButton(
                    onPressed: () async => Gal.open(),
                    child: const Text('Open Gallery'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.mp4');
                      await Gal.putVideo(path, album: album);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Save Video from file path'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.jpg');
                      await Gal.putImage(path, album: album);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Save Image from file path'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final byteData = await rootBundle.load('assets/done.jpg');
                      final uint8List = byteData.buffer.asUint8List(
                          byteData.offsetInBytes, byteData.lengthInBytes);
                      await Gal.putImageBytes(Uint8List.fromList(uint8List));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Save Image from bytes'),
                  ),
                  FilledButton(
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
                    child: const Text('Download Image'),
                  ),
                  FilledButton(
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
                    child: const Text('Download Video'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final hasAccess = await Gal.hasAccess(toAlbum: toAlbum);
                      log('Has Access:${hasAccess.toString()}');
                    },
                    child: const Text('Has Access'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final requestGranted =
                          await Gal.requestAccess(toAlbum: toAlbum);
                      log('Request Granted:${requestGranted.toString()}');
                    },
                    child: const Text('Request Access'),
                  ),

                  // This is for XCTest.
                  FilledButton(
                    onPressed: () async => Gal.requestAccess(toAlbum: true),
                    child: const Text('Request Access to Album'),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String? get album => toAlbum ? 'Album' : null;

  SnackBar get snackBar => SnackBar(
        content: const Text('Saved! ✅'),
        action: SnackBarAction(
          label: 'Gallery ->',
          onPressed: () async => Gal.open(),
        ),
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
