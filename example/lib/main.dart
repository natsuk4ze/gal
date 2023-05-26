import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () async {
                  Gal.open();
                },
                child: const Text('Open Gallery'),
              ),
              FilledButton(
                onPressed: () async {
                  final byteData = await rootBundle.load('assets/done.mp4');

                  final tempDir = await getTemporaryDirectory();
                  final file = await File('${tempDir.path}/video.mp4').create();
                  await file.writeAsBytes(byteData.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes));
                  Gal.putVideo(file.path);
                },
                child: const Text('Put Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
