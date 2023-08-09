import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/src/gal_exception.dart';

import 'gal_platform_interface.dart';

/// Main class of gal.
///
/// NOTE: For Android emulators with API < 29 will save media
/// on the SD card. Therefore, be sure to set the SD card. You can ignore
/// this for real devices.
/// See: [wiki](https://github.com/natsuk4ze/gal/wiki)
@immutable
final class Gal {
  const Gal._();

  /// Save a video to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putVideo(String path, {String? album}) async =>
      _voidOrThrow(
          () async => GalPlatform.instance.putVideo(path, album: album));

  /// Save a image to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImage(String path, {String? album}) async =>
      _voidOrThrow(
          () async => GalPlatform.instance.putImage(path, album: album));

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImageBytes(Uint8List bytes, {String? album}) async =>
      _voidOrThrow(
          () async => GalPlatform.instance.putImageBytes(bytes, album: album));

  /// Open gallery app.
  ///
  /// If there are multiple gallery apps, App selection sheet may be displayed.
  static Future<void> open() async => GalPlatform.instance.open();

  /// Check if the app has access permissions.
  ///
  /// On iOS, use the [toAlbum] option, which requires additional permissions
  /// to save to an album. on android, it is ignored. If you want to save to 
  /// an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> hasAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.hasAccess(toAlbum: toAlbum);

  /// Request access permissions.
  ///
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// On iOS, use the [toAlbum] option, which requires additional permissions
  /// to save to an album.
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> requestAccess({bool toAlbum = false}) async =>
      GalPlatform.instance.requestAccess(toAlbum: toAlbum);

  /// Throw [GalException] when [PlatformException] was throwed by native api.
  static Future<void> _voidOrThrow(Future<void> Function() cb) async {
    try {
      return await cb();
    } on PlatformException catch (error, stackTrace) {
      throw GalException.fromCode(
          code: error.code, error: error, stackTrace: stackTrace);
    }
  }
}
