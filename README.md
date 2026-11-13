<div align="center">

<img src="https://github.com/natsuk4ze/gal/raw/main/assets/logo.png" width="160" height="160" alt="Gal">

# Gal

**Save images and videos to the photo gallery with a single line of Dart.**

Android · iOS · macOS · Windows

[![pub version](https://img.shields.io/pub/v/gal?style=flat-square&color=2E8B57&label=pub)](https://pub.dev/packages/gal)
[![pub points](https://img.shields.io/pub/points/gal?style=flat-square&color=2E8B57)](https://pub.dev/packages/gal/score)
[![CI](https://img.shields.io/github/actions/workflow/status/natsuk4ze/gal/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/natsuk4ze/gal/actions/workflows/ci.yml)
[![license](https://img.shields.io/github/license/natsuk4ze/gal?style=flat-square&color=2E8B57)](https://github.com/natsuk4ze/gal/blob/main/LICENSE)
<a href="https://deepwiki.com/natsuk4ze/gal"><picture><source srcset="https://img.shields.io/badge/Ask-DeepWiki-2E8B57?style=flat-square"><img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki"></picture></a>

[**pub.dev**](https://pub.dev/packages/gal) &nbsp;·&nbsp;
[**API Reference**](https://pub.dev/documentation/gal/latest/) &nbsp;·&nbsp;
[**DeepWiki**](https://deepwiki.com/natsuk4ze/gal) &nbsp;·&nbsp;
[**Example**](https://github.com/natsuk4ze/gal/blob/main/example/lib/main.dart) &nbsp;·&nbsp;
[**Q&A**](https://github.com/natsuk4ze/gal/discussions/categories/q-a)

</div>

<br>

```dart
import 'package:gal/gal.dart';

await Gal.putImage(path);       // Save an image file
await Gal.putVideo(path);       // Save a video file
await Gal.putImageBytes(bytes); // Save image bytes

await Gal.hasPermission();      // Check the permission
await Gal.requestPermission();  // Ask for the permission
```

## 💚 Support Gal

<div align="center">

Gal is built and maintained by volunteers.<br>
If it saves you time, a like, a star or a sponsorship keeps it going.

[![Like on pub.dev](https://img.shields.io/pub/likes/gal?style=for-the-badge&logo=dart&logoColor=white&label=Like%20on%20pub.dev&color=0175C2)](https://pub.dev/packages/gal)
[![Star on GitHub](https://img.shields.io/github/stars/natsuk4ze/gal?style=for-the-badge&logo=github&label=Star%20on%20GitHub&color=2E8B57)](https://github.com/natsuk4ze/gal)
[![Sponsor](https://img.shields.io/badge/Sponsor-natsuk4ze-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/natsuk4ze)

</div>

## ✨ Highlights

- **Simple API** — Save with `putImage`, `putVideo` or `putImageBytes`. Each is a single static call.
- **Ultra-lightweight** — No dependencies besides Flutter.
- **Albums** — Save to a named album. It is created if it does not exist.
- **Permissions built in** — Gal asks for access only when it needs it. Take control with `hasPermission` and `requestPermission`.
- **Metadata kept** — EXIF and other metadata are saved along with the file.
- **Typed errors** — Every failure is a `GalException` with a clear `GalExceptionType`.
- **Easy to test** — Replace the platform with a fake in your unit tests.
- **Tested in CI** — Integration tests run on Android, iOS, macOS and Windows.

## 📱 Platforms

<div align="center">

|             | Android | iOS | macOS | Windows | Linux |
| :---------: | :-----: | :-: | :---: | :-----: | :---: |
| **Minimum** | API 24  | 13  |  11   |   10    | [`gal_linux`](https://pub.dev/packages/gal_linux) |

</div>

Every function is tested on each platform, [automatically](https://github.com/natsuk4ze/gal/actions/workflows/ci.yml) wherever possible.
Linux is available through [`gal_linux`](https://pub.dev/packages/gal_linux), a community plugin that is not officially endorsed.

## 📸 Demo

<div align="center">

| iOS | Android |
| :-: | :-----: |
| <img src="https://github.com/natsuk4ze/gal/raw/main/assets/ios.gif" width="260" alt="Gal on iOS"> | <img src="https://github.com/natsuk4ze/gal/raw/main/assets/android.gif" width="260" alt="Gal on Android"> |

</div>

## 🚀 Getting Started

### 1. Install

```sh
flutter pub add gal
```

### 2. Set up each platform

<details>
<summary><b>iOS</b></summary>
<br>

Add the following keys to `ios/Runner/Info.plist`:

```xml
<!-- Required -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save photos and videos to your library.</string>

<!-- Required for iOS 13 or saving to an album -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Save photos and videos to an album.</string>
```

See the [example's Info.plist](https://github.com/natsuk4ze/gal/blob/main/example/ios/Runner/Info.plist).

</details>

<details>
<summary><b>Android</b></summary>
<br>

Add the following to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Required for API 29 and below -->
<uses-permission
    android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29" />

<!-- Required for saving to an album on API 29 -->
<application android:requestLegacyExternalStorage="true">
```

See the [example's AndroidManifest.xml](https://github.com/natsuk4ze/gal/blob/main/example/android/app/src/main/AndroidManifest.xml).

> ⚠️ Android emulators with API below 29 need an SD card set up. Real devices don't.

</details>

<details>
<summary><b>macOS</b></summary>
<br>

Add the following keys to `macos/Runner/Info.plist`:

```xml
<!-- Required -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save photos and videos to your library.</string>

<!-- Required for saving to an album -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Save photos and videos to an album.</string>
```

See the [example's Info.plist](https://github.com/natsuk4ze/gal/blob/main/example/macos/Runner/Info.plist).

> ⚠️ Flutter has a [known issue with loading Info.plist](https://github.com/flutter/flutter/issues/134191) that can cause permission denials or crashes when running from some code editors.

</details>

<details>
<summary><b>Windows</b></summary>
<br>

Update [Visual Studio](https://visualstudio.microsoft.com) to the latest version to build with C++20.

> 💡 If the build still fails, install the latest Windows SDK from
> **Visual Studio Installer** → **Modify** → **Windows SDK**.

</details>

<details>
<summary><b>Linux</b></summary>
<br>

Linux is not officially supported. Use the community plugin [`gal_linux`](https://pub.dev/packages/gal_linux).

</details>

## 💻 Usage

### Save images and videos

```dart
// From a file. The path must include the extension.
await Gal.putImage('$filePath');
await Gal.putVideo('$filePath');

// From bytes. The extension is detected from the bytes.
await Gal.putImageBytes(bytes, name: 'photo');

// To an album. It is created if it does not exist.
await Gal.putImage('$filePath', album: 'My Album');

// Open the gallery app
await Gal.open();
```

### Recipes

<details>
<summary><b>Download from the internet</b></summary>
<br>

```sh
flutter pub add dio
```

```dart
final path = '${Directory.systemTemp.path}/image.jpg';
await Dio().download('$url', path);
await Gal.putImage(path);
```

</details>

<details>
<summary><b>Take a photo</b></summary>
<br>

```sh
flutter pub add image_picker
```

```dart
final image = await ImagePicker().pickImage(source: ImageSource.camera);
if (image != null) await Gal.putImage(image.path);
```

</details>

<details>
<summary><b>Record a video</b></summary>
<br>

```sh
flutter pub add camera
```

```dart
await controller.startVideoRecording();
// ...
final video = await controller.stopVideoRecording();
await Gal.putVideo(video.path);
```

</details>

### Permissions

`put` methods ask for permission when the app does not have it yet, so you don't need to request it beforehand.
Request it yourself only to choose when the dialog appears, for example after showing your own explanation.

```dart
final hasPermission = await Gal.hasPermission();
final granted = await Gal.requestPermission();

// For saving to an album
await Gal.hasPermission(toAlbum: true);
await Gal.requestPermission(toAlbum: true);
```

### Errors

Every error is a `GalException`. Use its `type` to decide what to do.

```dart
try {
  await Gal.putImage('$filePath');
} on GalException catch (e) {
  log(e.type.message);
}
```

| `GalExceptionType`   | When                                                                                     |
| :------------------- | :--------------------------------------------------------------------------------------- |
| `permissionDenied`   | The app does not have permission to access the gallery.                                  |
| `notEnoughSpace`     | The device does not have enough storage.                                                 |
| `notSupportedFormat` | The OS does not support the file type or video codec. The path must include the extension. `putImage` and `putVideo` on Android and Windows do not look inside the file. |
| `unexpected`         | Anything else. Please [open an issue](https://github.com/natsuk4ze/gal/issues) with `platformException` and `stackTrace`. |

### Testing

Gal calls native code, which does not run in unit tests or widget tests.
In most cases, wrap Gal in your own class and mock that class.

To replace Gal itself, extend `GalPlatform` from `package:gal/gal_platform_interface.dart` and set it to `GalPlatform.instance`.
Methods that the fake does not override throw `UnimplementedError`.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/gal_platform_interface.dart';

final class FakeGalPlatform extends GalPlatform {
  @override
  Future<void> putImage(String path, {String? album}) async {}
}

void main() {
  setUp(() => GalPlatform.instance = FakeGalPlatform());

  test('saves the image', () => Gal.putImage('image.jpg'));
}
```

## 📚 Resources

- 🎯 [**Example**](https://github.com/natsuk4ze/gal/blob/main/example/lib/main.dart) — An app that uses every API
- 📖 [**API Reference**](https://pub.dev/documentation/gal/latest/) — Documentation for every class and method
- 🧠 [**DeepWiki**](https://deepwiki.com/natsuk4ze/gal) — How Gal works, explained by AI
- 💬 [**Q&A**](https://github.com/natsuk4ze/gal/discussions/categories/q-a) — Ask questions
- 💚 [**Contributing**](https://github.com/natsuk4ze/gal/blob/main/CONTRIBUTING.md) — How to send issues and PRs

Wrote an article about Gal? Let us know in [Discussions](https://github.com/natsuk4ze/gal/discussions) and we'll link it here.

## 🤝 Trusted By

| Project | About | Stars |
| :------ | :---- | :---: |
| [**LocalSend**](https://github.com/localsend/localsend) | Share files to nearby devices | ![stars](https://img.shields.io/github/stars/localsend/localsend?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Flutter Quill**](https://github.com/singerdmx/flutter-quill) | Rich text editor | ![stars](https://img.shields.io/github/stars/singerdmx/flutter-quill?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Moodiary**](https://github.com/ZhuJHua/moodiary) | Diary app | ![stars](https://img.shields.io/github/stars/ZhuJHua/moodiary?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Turms**](https://github.com/turms-im/turms) | Instant messaging engine | ![stars](https://img.shields.io/github/stars/turms-im/turms?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Lotti**](https://github.com/matthiasn/lotti) | Private logbook with AI assistants | ![stars](https://img.shields.io/github/stars/matthiasn/lotti?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Pho**](https://github.com/fregie/pho) | Photo sync to cloud storage | ![stars](https://img.shields.io/github/stars/fregie/pho?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Stream Chat**](https://github.com/GetStream/stream-chat-flutter) | Chat SDK | ![stars](https://img.shields.io/github/stars/GetStream/stream-chat-flutter?style=flat-square&label=%E2%AD%90&color=2E8B57) |
| [**Thunder**](https://github.com/thunder-app/thunder) | Lemmy client | ![stars](https://img.shields.io/github/stars/thunder-app/thunder?style=flat-square&label=%E2%AD%90&color=2E8B57) |

…and many more.

<br>

<div align="center">
<sub>Released under the <a href="https://github.com/natsuk4ze/gal/blob/main/LICENSE">BSD 3-Clause License</a> · Made with 💚 by <a href="https://github.com/natsuk4ze">@natsuk4ze</a></sub>
</div>
