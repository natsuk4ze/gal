# Gal💚

[![pub points](https://img.shields.io/pub/points/gal?color=2E8B57&label=pub%20points)](https://pub.dev/packages/gal/score)
![CI](https://github.com/Midori-Design-Studio/gal/actions/workflows/analyze.yml/badge.svg?branch=main)
[![License](https://img.shields.io/badge/license-BSD3-blue.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/gal.svg)](https://pub.dev/packages/gal)

Hi👋 Gal is very easy to use Flutter Plugin for handle native gallery apps, iOS <img src="https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/fe/3a/7e/fe3a7e0e-7f52-b750-0ed2-523998c59d48/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.webp" alt="ios photo" width="20" height="20"/> and Android <img src="https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" alt="amdroid photo" width="20" height="20"/>.

![example](https://github.com/Midori-Design-Studio/gal/raw/main/example/assets/example.gif)

## Features

* Open gallery
* Save video
* Save image

## Installation

First, add `gal` as a
[dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### iOS

Add the following key to your _Info.plist_ file, located in
`<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryAddUsageDescription` - you can copy from [Info.plist in example](https://github.com/Midori-Design-Studio/gal/blob/main/example/ios/Runner/Info.plist).

## Example

``` dart
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                onPressed: () async => Gal.putVideo('TODO: Change this text to video path'),
                label: const Text('Save Video'),
                icon: const Icon(Icons.video_file),
              ),
              FilledButton.icon(
                onPressed: () async => Gal.putImage('TODO: Change this text to image path'),
                label: const Text('Save Image'),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Contributing

Welcome💚 Feel free to create issue or PR. Basically, please follows [Effective Dart](https://dart.dev/effective-dart).
