import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/src/gal_exception.dart';

import 'gal_platform_interface.dart';

/// A main class of gal.
///
/// See: [wiki](https://github.com/natsuk4ze/gal/wiki)
@immutable
final class Gal {
  const Gal._();

  /// Save a video to the gallery from file [path].
  ///
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putVideo(String path) async =>
      _voidOrThrow(() async => GalPlatform.instance.putVideo(path));

  /// Save a image to the gallery from file [path].
  ///
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImage(String path) async =>
      _voidOrThrow(() async => GalPlatform.instance.putImage(path));

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Save a image directly from memory without using a temporary file.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImageBytes(Uint8List bytes) async =>
      _voidOrThrow(() async => GalPlatform.instance.putImageBytes(bytes));

  /// Open the default gallery app.
  static Future<void> open() async => GalPlatform.instance.open();

  /// Check if the app has access permissions.
  /// 
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> hasAccess() async => GalPlatform.instance.hasAccess();

  /// Request access permissions.
  /// 
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> requestAccess() async =>
      GalPlatform.instance.requestAccess();

  static Future<void> _voidOrThrow(Future<void> Function() cb) async {
    try {
      return await cb();
    } on PlatformException catch (error, stackTrace) {
      throw GalException.fromCode(
          code: error.code, error: error, stackTrace: stackTrace);
    }
  }
}
