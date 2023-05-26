import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gal/gal.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Gal Example 💚",
            style: Theme.of(context).textTheme.titleLarge,
          )),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () async => Gal.open(),
                label: const Text('Open Gallery'),
                icon: const Icon(Icons.open_in_new),
              ),
              FilledButton.icon(
                onPressed: () async =>
                    Gal.putVideo(await getFilePath('assets/done.mp4')),
                label: const Text('Save Video'),
                icon: const Icon(Icons.video_file),
              ),
              FilledButton.icon(
                onPressed: () async =>
                    Gal.putImage(await getFilePath('assets/done.jpg')),
                label: const Text('Save Image'),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
        ),
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
