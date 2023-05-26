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
        appBar: AppBar(
          title: Center(
              child: Text(
            "Gal Example 💚",
            style: Theme.of(context).textTheme.titleLarge,
          )),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async => Gal.open(),
                    label: const Text('Open Gallery'),
                    icon: const Icon(Icons.open_in_new),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.mp4');
                      await Gal.putVideo(path);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    label: const Text('Save Video'),
                    icon: const Icon(Icons.video_file),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      final path = await getFilePath('assets/done.jpg');
                      await Gal.putImage(path);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    label: const Text('Save Image'),
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
            );
          }
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
