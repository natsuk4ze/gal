# Gal 🖼️

![Since](https://img.shields.io/badge/since-2023.06-purple)
[![pub points](https://img.shields.io/pub/points/gal?color=2E8B57&label=pub%20points)](https://pub.dev/packages/gal/score)
[![Maintainability](https://api.codeclimate.com/v1/badges/4472a09f02bff9d6e0b9/maintainability)](https://codeclimate.com/github/natsuk4ze/gal/maintainability)
[![CodeFactor](https://www.codefactor.io/repository/github/natsuk4ze/gal/badge)](https://www.codefactor.io/repository/github/natsuk4ze/gal)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3a20a89327ba43c789c0dc8465e16168)](https://app.codacy.com/gh/natsuk4ze/gal/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
![CI](https://github.com/natsuk4ze/gal/actions/workflows/ci.yml/badge.svg?branch=main)
[![pub package](https://img.shields.io/pub/v/gal.svg)](https://pub.dev/packages/gal)

## Dart3 plugin for saving image or video to gallery/photos <img src="https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/fe/3a/7e/fe3a7e0e-7f52-b750-0ed2-523998c59d48/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.webp" alt="ios photos" width="20" height="20"/> <img src="https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" alt="google photos" width="20" height="20"/> <img src="https://upload.wikimedia.org/wikipedia/en/9/94/Microsoft_Photos_logo.png" alt="microsoft photos" width="22" height="22"/> 
### Please [LIKE👍](https://pub.dev/packages/gal) and [STAR⭐️](https://github.com/natsuk4ze/gal) to support our volunteer efforts.
|             | Android | iOS | macOS | Windows |
|-------------|---------|-----|-------|---------|
| **Support** | SDK 21+ | 11+ |  11+  |   10+   |

|             | iOS | Android |
|-------------|-----|---------|
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

Add the following keys to the `ios/Runner/Info.plist`:

* `<key>NSPhotoLibraryAddUsageDescription</key>` Required
* `<key>NSPhotoLibraryUsageDescription</key>` Required for ios < 14 or saving to album

You can copy from [Info.plist in example](https://github.com/natsuk4ze/gal/blob/main/example/ios/Runner/Info.plist).

### Android

Add the following keys to the `android/app/src/main/AndroidManifest.xml`:

* `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="29" />` Required for API <= 29
* `android:requestLegacyExternalStorage="true"` Required for saving to album in API 29

You can copy from [AndroidManifest.xml in example](https://github.com/natsuk4ze/gal/blob/main/example/android/app/src/main/AndroidManifest.xml).

> **🔴 Warning:**
Android emulators with API < 29 require SD card setup. Real devices don't.

### macOS

Add the following keys to the `macos/Runner/Info.plist`:

* `<key>NSPhotoLibraryAddUsageDescription</key>` Required
* `<key>NSPhotoLibraryUsageDescription</key>` Required for saving to album

You can copy from [Info.plist in example](https://github.com/natsuk4ze/gal/blob/main/example/macos/Runner/Info.plist).

> **🔴 Warning:**
Flutter has [fatal crash issee for loading info.plist on macOS](https://github.com/flutter/flutter/issues/134191) now.

### Windows

We recommend that you update [Visual Studio](https://visualstudio.microsoft.com) to the latest version for using `C++ 20`.

### Linux
The following command executables are required to use this plugin:
1. `mkdir`
2. `cp`
3. `rm`
4. `wget`


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


## 📝 Ducuments
If you write an article about gal, let us know on dissucussion and we will post the URL of the article in the wiki or readme 🤝

- ### [🎯 Example](https://github.com/natsuk4ze/gal/blob/main/example/lib/main.dart)
- ### [👌 Best Practice](https://github.com/natsuk4ze/gal/wiki/Best-Practice)
- ### [🏠 Wiki](https://github.com/natsuk4ze/gal/wiki)
- ### [💬 Q&A](https://github.com/natsuk4ze/gal/discussions/categories/q-a)
- ### [💚 Contributing](https://github.com/natsuk4ze/gal/blob/main/CONTRIBUTING.md)

## 💚 Trusted by huge projects
Although gal has only been released for a short time, it is already trusted by huge projects.

- ### [localsend - 15k⭐️](https://github.com/localsend/localsend)
- ### [flutter-quill - 2.1k⭐️](https://github.com/singerdmx/flutter-quill)
and more...
