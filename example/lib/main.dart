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
                onPressed: () async {
                  final byteData = await rootBundle.load('assets/done.mp4');
                  final file =
                      await File('${Directory.systemTemp.path}/done.mp4')
                          .create();
                  await file.writeAsBytes(byteData.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes));

                  await Gal.putVideo(file.path);
                },
                label: const Text('Save Video'),
                icon: const Icon(Icons.download),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
