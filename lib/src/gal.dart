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
  /// {@template gal.put.permission}
  /// If the app does not have permission yet, this requests it first, so you
  /// do not need to call [requestPermission] beforehand.
  /// {@endtemplate}
  /// Throws a [GalException] if permission is denied or
  /// if an error occurs during saving.
  /// The OS must support both the file type and the video codec,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  /// Android and Windows save the file as is, without checking its format,
  /// except that Android 10 and later require a known video extension.
  static Future<void> putVideo(String path, {String? album}) async =>
      GalPlatform.instance.putVideo(path, album: album);

  /// Save an image to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// [path] must include the file extension.
  /// ```dart
  /// await Gal.putImage('${Directory.systemTemp.path}/image.jpg');
  /// ```
  /// {@macro gal.put.permission}
  /// Throws a [GalException] if permission is denied or
  /// if an error occurs during saving.
  /// The OS must support the file type,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  /// Android and Windows save the file as is, without checking its format,
  /// except that Android 10 and later require a known image extension.
  static Future<void> putImage(String path, {String? album}) async =>
      GalPlatform.instance.putImage(path, album: album);

  /// Save an image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Specify the file name with [name]. Do not include the extension.
  /// The extension is detected from [bytes], so it may differ from
  /// the original file. Prefer [putImage] for uncommon formats such as
  /// camera RAW.
  /// ```dart
  /// await Gal.putImageBytes(bytes, name: 'photo');
  /// ```
  /// {@macro gal.put.permission}
  /// Throws a [GalException] if permission is denied or
  /// if an error occurs during saving.
  /// The OS must support the image format,
  /// or [GalExceptionType.notSupportedFormat] is thrown.
  static Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    String name = 'image',
  }) async =>
      GalPlatform.instance.putImageBytes(bytes, album: album, name: name);

  /// Open the gallery app.
  ///
  /// If there are multiple gallery apps, an app selection sheet may be
  /// displayed.
  static Future<void> open() async => GalPlatform.instance.open();

  /// Check if the app has permission to save to the gallery.
  ///
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// On iOS and macOS, it also returns true when the user allows only limited
  /// access. With limited access, albums created by the user or other apps
  /// cannot be found, so saving to one of them creates a new album
  /// with the same name.
  static Future<bool> hasPermission({bool toAlbum = false}) async =>
      GalPlatform.instance.hasPermission(toAlbum: toAlbum);

  /// Request permission to save to the gallery.
  ///
  /// Returns true if permission is granted, false if denied.
  /// If permission was already granted, the dialog is not displayed
  /// and returns true.
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// On iOS and macOS, the dialog is shown only once. If the user denies it,
  /// permission can only be changed in the Settings app.
  /// On Android API 24 to 29, the dialog is shown each time until
  /// the user selects "Don't ask again".
  /// See [hasPermission] for limited access on iOS and macOS.
  static Future<bool> requestPermission({bool toAlbum = false}) async =>
      GalPlatform.instance.requestPermission(toAlbum: toAlbum);
}
