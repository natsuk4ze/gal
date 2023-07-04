import 'package:flutter/services.dart';
import 'package:gal/src/gal_exception.dart';

import 'gal_platform_interface.dart';

/// For detailed please see
/// https://github.com/natsuk4ze/gal/wiki
/// these functions are first called,
/// [putImage],[putVideo],[putImageBytes],a native dialog is 
/// called asking the use for permission. If the user chooses to deny,
/// [GalException] of [GalExceptionType.accessDenied] will be throwed.
/// You should either do error handling or call [requestAccess] once
/// before calling these function.
final class Gal {
  Gal._();

  /// Save video to standard gallery app
  /// [path] is local path.
  static Future<void> putVideo(String path) async =>
      _voidOrThrow(() async => GalPlatform.instance.putVideo(path));

  /// Save image to standard gallery app
  /// [path] is local path.
  static Future<void> putImage(String path) async =>
      _voidOrThrow(() async => GalPlatform.instance.putImage(path));

  /// Save image to standard gallery app
  /// [Uint8List] version of [putImage]
  /// It does not require temporary files and saves directly from memory,
  /// making it fast.
  static Future<void> putImageBytes(Uint8List bytes) async =>
      _voidOrThrow(() async => GalPlatform.instance.putImageBytes(bytes));

  /// Open OS standard gallery app.
  /// Open "iOS Photos" when iOS, "Google Photos" or something when Android.
  static Future<void> open() async => GalPlatform.instance.open();

  /// Returns whether or not the app has access.
  /// For Android API >=29, or <23, this request is unnecessary and returns true.
  /// For details please see
  /// https://github.com/natsuk4ze/gal/wiki/Permissions
  static Future<bool> hasAccess() async => GalPlatform.instance.hasAccess();

  /// Displays a dialog for the request and returns whether the user has accepted.
  /// If access was already granted, the dialog is not displayed
  /// and returns true.
  /// On iOS, once the user rejects it, the dialog cannot be displayed and
  /// returns false immediately.
  /// For Android API >=29, or <23, this request is unnecessary and returns true.
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
