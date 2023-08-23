# Gal 🖼️

[![pub points](https://img.shields.io/pub/points/gal?color=2E8B57&label=pub%20points)](https://pub.dev/packages/gal/score)
[![Maintainability](https://api.codeclimate.com/v1/badges/4472a09f02bff9d6e0b9/maintainability)](https://codeclimate.com/github/natsuk4ze/gal/maintainability)
[![CodeFactor](https://www.codefactor.io/repository/github/natsuk4ze/gal/badge)](https://www.codefactor.io/repository/github/natsuk4ze/gal)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3a20a89327ba43c789c0dc8465e16168)](https://app.codacy.com/gh/natsuk4ze/gal/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
![CI](https://github.com/natsuk4ze/gal/actions/workflows/ci.yml/badge.svg?branch=main)
[![License](https://img.shields.io/badge/license-BSD3-blue.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/gal.svg)](https://pub.dev/packages/gal)

### Dart3 plugin for saving image/video to gallery <img src="https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/fe/3a/7e/fe3a7e0e-7f52-b750-0ed2-523998c59d48/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.webp" alt="ios photo" width="20" height="20"/> <img src="https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" alt="amdroid photo" width="20" height="20"/> 
**Please [like👍](https://pub.dev/packages/gal) and [star⭐️](https://github.com/natsuk4ze/gal) for more.**
| **Support** |    iOS 11.0+   | Android SDK 21+ |
|-------------|----------------|-----------------|
| **Example** | <img src="https://github.com/natsuk4ze/gal/raw/main/readme_assets/ios.gif" alt="ios" width="270"/> | <img src="https://github.com/natsuk4ze/gal/raw/main/readme_assets/android.gif" alt="android" width="270"/> |


## ✨ Features

* Open gallery
* Save video
* Save image
* Save to album
* Save with metadata
* Handle permission
* Handle errors
* Lots of docs and wiki

## 🚀 Get started

### Add dependency

You can use the command to add gal as a dependency with the latest stable version:

```console
$ flutter pub add gal
```

### iOS

Add the following key to your _Info.plist_ file, located in
`<project root>/ios/Runner/Info.plist`:

* `<key>NSPhotoLibraryAddUsageDescription</key>`
* `<key>NSPhotoLibraryUsageDescription</key>` Requried If you want to save media to album.

you can copy from [Info.plist in example](https://github.com/natsuk4ze/gal/blob/main/example/ios/Runner/Info.plist).

### Android (API <29)

Add the following key to your _AndroidManifest_ file, located in
`<project root>/android/app/src/main/AndroidManifest.xml`:

* `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="29" />`

you can copy from [AndroidManifest.xml in example](https://github.com/natsuk4ze/gal/blob/main/example/android/app/src/main/AndroidManifest.xml).

> **🔴 Warning:**
Android emulators with API < 29 require SD card setup. Real devices don't.

## ✅ Usage

### Save from local

```dart
// Save Image (Supports two ways)
await Gal.putImage('$filePath');
await Gal.putImageBytes('$uint8List');

// Save Video
await Gal.putVideo('$filePath');

// Save to album
await Gal.putImage('$filePath', album: '$album')
...
```

### Download from Internet

```console
$ flutter pub add dio
```

```dart
// Download Image
final imagePath = '${Directory.systemTemp.path}/image.jpg';
await Dio().download('$url',imagePath);
await Gal.putImage(imagePath);

// Download Video
final videoPath = '${Directory.systemTemp.path}/video.mp4';
await Dio().download('$url',videoPath);
await Gal.putVideo(videoPath);
```

### Save from Camera

```console
$ flutter pub add image_picker
```

```dart
// Shot and Save
final image = await ImagePicker.pickImage(source: ImageSource.camera);
await Gal.putImage(image.path);
```

```console
$ flutter pub add camera
```
```dart
// Record and Save
...
final video = await controller.stopVideoRecording();
await Gal.putVideo(video.path);
```

### Handle Permission

```dart
// Check Permission
await Gal.hasAccess();

// Request Permission
await Gal.requestAccess();
```

### Handle Errors

```dart
// Save Image with try-catch
try {
  await Gal.putImage($imagePath);
} on GalException catch (e) {
  log(e.type.message);
}

// Exception Type
enum GalExceptionType {
  accessDenied,
  notEnoughSpace,
  notSupportedFormat,
  unexpected;

  String get message => switch (this) {
        accessDenied => 'You do not have permission to access the gallery app.',
        notEnoughSpace => 'Not enough space for storage.',
        notSupportedFormat => 'Unsupported file formats.',
        unexpected => 'An unexpected error has occurred.',
      };
}
```


## 🎯 Example

Here is a minimal example. A [best practice](https://github.com/natsuk4ze/gal/wiki/Best-Practice) and more detailed one 
can be found in [example](https://pub.dev/packages/gal/example).

``` dart
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextButton(
              onPressed: () async => Gal.open(),
              child: const Text('Open Gallery'),
            ),
            TextButton(
              onPressed: () async => Gal.putVideo('VIDEO_PATH'),
              child: const Text('Save Video'),
            ),
            TextButton(
              onPressed: () async => Gal.putImage('IMAGE_PATH'),
              child: const Text('Save Image'),
            ),
            TextButton(
              onPressed: () async => Gal.hasAccess(),
              child: const Text('Chack Permission'),
            ),
            TextButton(
              onPressed: () async => Gal.requestAccess(),
              child: const Text('Request Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
```


## 📝 Ducuments

- ### [👌 Best Practice](https://github.com/natsuk4ze/gal/wiki/Best-Practice)
- ### [🏠 Wiki](https://github.com/natsuk4ze/gal/wiki)
- ### [💬 Q&A](https://github.com/natsuk4ze/gal/discussions/categories/q-a)
- ### [💚 Contributing](https://github.com/natsuk4ze/gal/blob/main/CONTRIBUTING.md)
