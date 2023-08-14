import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

const _channel = MethodChannel('gal');

/// Plugin Communication
@immutable
final class GalPlatform {
  const GalPlatform._();

  static Future<T?> _invokeMethod<T>(
      String method, Map<String, dynamic> args) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on PlatformException catch (error, stackTrace) {
      throw GalException.fromCode(
          code: error.code, error: error, stackTrace: stackTrace);
    }
  }

  static Future<void> putVideo(String path, {String? album}) =>
      _invokeMethod<void>('putVideo', {'path': path, 'album': album});

  static Future<void> putImage(String path, {String? album}) =>
      _invokeMethod<void>('putImage', {'path': path, 'album': album});

  static Future<void> putImageBytes(Uint8List bytes, {String? album}) =>
      _invokeMethod<void>('putImageBytes', {'bytes': bytes, 'album': album});

  static Future<void> open() async => _invokeMethod<void>('open', {});

  static Future<bool> hasAccess({bool toAlbum = false}) async {
    final hasAccess =
        await _invokeMethod<bool>('hasAccess', {'toAlbum': toAlbum});
    return hasAccess ?? false;
  }

  static Future<bool> requestAccess({bool toAlbum = false}) async {
    final granted =
        await _invokeMethod<bool>('requestAccess', {'toAlbum': toAlbum});
    return granted ?? false;
  }
}
