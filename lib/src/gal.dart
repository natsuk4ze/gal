import 'package:flutter/foundation.dart';
import 'package:gal/src/gal_exception.dart';
import 'package:gal/src/gal_platform_interface.dart';

/// Main class of gal.
///
/// See: [README](https://github.com/natsuk4ze/gal#readme)
/// and [DeepWiki](https://deepwiki.com/natsuk4ze/gal)
@immutable
final class Gal {
  const Gal._();

  /// Save a video to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// [path] must include the file extension.
  /// ```dart
  /// await Gal.putVideo('${Directory.systemTemp.path}/video.mp4');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// The OS must support both the file type and the video codec,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  /// Windows saves the file as is, without checking its format.
  static Future<void> putVideo(String path, {String? album}) async =>
      GalPlatform.instance.putVideo(path, album: album);

  /// Save a image to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// [path] must include the file extension.
  /// ```dart
  /// await Gal.putImage('${Directory.systemTemp.path}/image.jpg');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// The OS must support the file type,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  /// Windows saves the file as is, without checking its format.
  static Future<void> putImage(String path, {String? album}) async =>
      GalPlatform.instance.putImage(path, album: album);

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Specify the file name with [name]. Do not include the extension.
  /// The extension is detected from [bytes], so it may differ from
  /// the original file. Use [putImage] to keep the original extension.
  /// ```dart
  /// await Gal.putImageBytes(bytes, name: 'photo');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// The OS must support the image format,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  static Future<void> putImageBytes(Uint8List bytes,
          {String? album, String name = 'image'}) async =>
      GalPlatform.instance.putImageBytes(bytes, album: album, name: name);

  /// Open gallery app.
  ///
  /// If there are multiple gallery apps, App selection sheet may be displayed.
  static Future<void> open() async => GalPlatform.instance.open();

  /// Check if the app has access permissions.
  ///
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// On iOS and macOS, it also returns true when the user allows only limited
  /// access. With limited access, albums created by the user or other apps
  /// cannot be found, so saving to one of them creates a new album
  /// with the same name.
  static Future<bool> hasAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.hasAccess(toAlbum: toAlbum);

  /// Request access permissions.
  ///
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// On iOS and macOS, the dialog is shown only once. If the user denies it,
  /// access can only be changed in the Settings app.
  /// On Android API 23 to 29, the dialog is shown each time until
  /// the user selects "Don't ask again".
  /// See [hasAccess] for limited access on iOS and macOS.
  static Future<bool> requestAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.requestAccess(toAlbum: toAlbum);
}
