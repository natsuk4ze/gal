import 'package:flutter/foundation.dart';
import 'package:gal/src/gal_exception.dart';
import 'package:gal/src/gal_platform_interface.dart';

/// Main class of gal.
///
/// See: [wiki](https://github.com/natsuk4ze/gal/wiki)
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
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
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
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImage(String path, {String? album}) async =>
      GalPlatform.instance.putImage(path, album: album);

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Do not include the extension in [name].
  /// ```dart
  /// await Gal.putImageBytes(bytes, name: 'photo');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
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
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> hasAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.hasAccess(toAlbum: toAlbum);

  /// Request access permissions.
  ///
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> requestAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.requestAccess(toAlbum: toAlbum);
}
