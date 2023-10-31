import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show Uint8List, immutable, kIsWeb;
import 'package:gal/src/gal_exception.dart';

/// Implmenetation for Linux platform
@immutable
final class GalLinuxImpl {
  const GalLinuxImpl._();

  static bool get isLinux {
    if (kIsWeb) {
      return false;
    }
    return Platform.isLinux;
  }

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
      throw UnsupportedError(
        'Linux is not supported yet.',
      );

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
      throw UnsupportedError(
        'Linux is not supported yet.',
      );

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImageBytes(Uint8List bytes, {String? album}) async =>
      throw UnsupportedError(
        'Linux is not supported yet.',
      );

  /// Open gallery app.
  ///
  /// If there are multiple gallery apps, App selection sheet may be displayed.
  static Future<void> open() async => throw UnsupportedError(
        'Linux is not supported yet.',
      );

  /// Check if the app has access permissions.
  ///
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> hasAccess({bool toAlbum = false}) async => true;

  /// Request access permissions.
  ///
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> requestAccess({bool toAlbum = false}) async => true;
}
