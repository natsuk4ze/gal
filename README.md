<p align="center">
  <p align="center">
   <img width="200" height="200" src="https://github.com/natsuk4ze/gal/raw/main/assets/logo.png" alt="Logo">
  </p>
 <h1 align="center"><b>Gal</b></h1>
 <h3 align="center">
  <b>
   Dart3 plugin for saving image or video to photos gallery
    <img src="https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/fe/3a/7e/fe3a7e0e-7f52-b750-0ed2-523998c59d48/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.webp" alt="ios photos" width="20" height="20"/> <img src="https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" alt="google photos" width="20" height="20"/> <img src="https://upload.wikimedia.org/wikipedia/en/9/94/Microsoft_Photos_logo.png" alt="microsoft photos" width="22" height="22"/>
  </b>
  </h3>
 <p align="center">
    <a href="https://pub.dev/packages/gal"><strong>pub.dev »</strong></a>
    <br />
    <br />
    <img src="https://img.shields.io/badge/since-2023.06-purple" alt="Since">
    <a href="https://pub.dev/packages/gal/score">
    <img src="https://img.shields.io/pub/points/gal?color=2E8B57&label=pub%20points" alt="pub points">
    </a>
    <a href="https://codeclimate.com/github/natsuk4ze/gal/maintainability">
    <img src="https://api.codeclimate.com/v1/badges/4472a09f02bff9d6e0b9/maintainability" alt="Maintainability">
    <a href="https://www.codefactor.io/repository/github/natsuk4ze/gal">
    <img src="https://www.codefactor.io/repository/github/natsuk4ze/gal/badge" alt="CodeFactor">
    <a href="https://app.codacy.com/gh/natsuk4ze/gal/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade">
    <img src="https://app.codacy.com/project/badge/Grade/3a20a89327ba43c789c0dc8465e16168" alt="Codacy Badge">
    <img src="https://github.com/natsuk4ze/gal/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI">
    <a href="https://pub.dev/packages/gal">
    <img src="https://img.shields.io/pub/v/gal.svg" alt="pub package">
    </a>  
  </p>
</p>

## 📢 Support Us

Please support our volunteer efforts by giving us a [LIKE👍](https://pub.dev/packages/gal) and [STAR⭐️](https://github.com/natsuk4ze/gal).

## 🧠 DeepWiki Documentation

[![DeepWiki](https://img.shields.io/badge/DeepWiki-Documentation-2E8B57?style=for-the-badge&logo=read-the-docs&logoColor=white)](https://deepwiki.com/natsuk4ze/gal/1-overview)

## 📱 Supported Platforms

|             | Android | iOS | macOS | Windows | Linux |
|-------------|---------|-----|-------|---------|-------|
| **Support** | SDK 21+ | 11+ |  11+  |   10+   | See: [gal_linux](https://pub.dev/packages/gal_linux) |

**Support** means that all functions have been tested manually or [automatically](https://github.com/natsuk4ze/gal/actions/runs/7517751549) whenever possible.

## 📸 Demo

|             | iOS | Android |
|-------------|-----|---------|
| **Example** | <img src="https://github.com/natsuk4ze/gal/raw/main/assets/ios.gif" alt="ios" width="270"/> | <img src="https://github.com/natsuk4ze/gal/raw/main/assets/android.gif" alt="android" width="270"/> |

## ✨ Features

* Open gallery
* Save video
* Save image
* Save to album
* Save with metadata
* Handle permission
* Handle errors
* Comprehensive documentation and wiki

## 🚀 Getting Started

### Add Dependency

Add the latest stable version of gal to your dependencies:

```console
flutter pub add gal
```

### iOS Setup

Add the following keys to `ios/Runner/Info.plist`:

* `<key>NSPhotoLibraryAddUsageDescription</key>` Required
* `<key>NSPhotoLibraryUsageDescription</key>` Required for iOS < 14 or saving to album

You can copy from [example's Info.plist](https://github.com/natsuk4ze/gal/blob/main/example/ios/Runner/Info.plist).

### Android Setup

Add the following keys to `android/app/src/main/AndroidManifest.xml`:

* `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="29" />` Required for API <= 29
* `android:requestLegacyExternalStorage="true"` Required for saving to album in API 29

You can copy from [example's AndroidManifest.xml](https://github.com/natsuk4ze/gal/blob/main/example/android/app/src/main/AndroidManifest.xml).

> **⚠️ Note:**
> Android emulators with API < 29 require SD card setup. Real devices don't.

### macOS Setup

Add the following keys to `macos/Runner/Info.plist`:

* `<key>NSPhotoLibraryAddUsageDescription</key>` Required
* `<key>NSPhotoLibraryUsageDescription</key>` Required for saving to album

You can copy from [example's Info.plist](https://github.com/natsuk4ze/gal/blob/main/example/macos/Runner/Info.plist).

> **⚠️ Note:**
> Flutter currently has a [fatal problem for loading info.plist](https://github.com/flutter/flutter/issues/134191), which may cause permission denials or app crashes in some code editors.

### Windows Setup

Update [Visual Studio](https://visualstudio.microsoft.com) to the latest version for using `C++ 20`.

> **💡 If you can't compile**
>
> Try downloading the latest Windows SDK:
>
> 1. Open Visual Studio Installer
> 2. Select Modify
> 3. Select Windows SDK

### Linux Setup

Linux is not officially supported, but can be added through a non-endorsed federated plugin.
See: [gal_linux](https://pub.dev/packages/gal_linux)

## 💻 Usage

### Save from Local

```dart
// Save Image (Supports two ways)
await Gal.putImage('$filePath');
await Gal.putImageBytes('$uint8List');

// Save Video
await Gal.putVideo('$filePath');

// Save to Album
await Gal.putImage('$filePath', album: '$album')
...
```

### Download from Internet

```console
flutter pub add dio
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
flutter pub add image_picker
```

```dart
// Capture and Save
final image = await ImagePicker.pickImage(source: ImageSource.camera);
await Gal.putImage(image.path);
```

```console
flutter pub add camera
```

```dart
// Record and Save
...
final video = await controller.stopVideoRecording();
await Gal.putVideo(video.path);
```

### Handle Permissions

```dart
// Check Access Permission
final hasAccess = await Gal.hasAccess();

// Request Access Permission
await Gal.requestAccess();

// ... for saving to album
final hasAccess = await Gal.hasAccess(toAlbum: true);
await Gal.requestAccess(toAlbum: true);
```

### Handle Errors

```dart
// Save Image with try-catch
try {
  await Gal.putImage('$filePath');
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
        accessDenied => 'Permission to access the gallery is denied.',
        notEnoughSpace => 'Not enough space for storage.',
        notSupportedFormat => 'Unsupported file format.',
        unexpected => 'An unexpected error has occurred.',
      };
}
```

## 📚 Documentation

If you write an article about Gal, let us know in the discussion and we'll post the URL in the wiki or readme 🤝

* ### [🎯 Example](https://github.com/natsuk4ze/gal/blob/main/example/lib/main.dart)

* ### [👌 Best Practices](https://github.com/natsuk4ze/gal/wiki/Best-Practice)

* ### [🏠 Official Wiki](https://github.com/natsuk4ze/gal/wiki)

* ### [💚 Contributing](https://github.com/natsuk4ze/gal/blob/main/CONTRIBUTING.md)

* ### [💬 Q&A](https://github.com/natsuk4ze/gal/discussions/categories/q-a)

## 💚 Trusted by Major Projects

Although Gal has only been released for a short time, it's already trusted by major projects.

* ### [localsend - 60k⭐️](https://github.com/localsend/localsend)

* ### [flutter-quill-extensions - 2.6k⭐️](https://github.com/singerdmx/flutter-quill)

* ### [stream-chat-flutter - 1k⭐️](https://github.com/GetStream/stream-chat-flutter)

* ### [Thunder - 0.8k⭐️](https://github.com/thunder-app/thunder)

and more...
