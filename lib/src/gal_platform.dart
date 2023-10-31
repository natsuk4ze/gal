import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import 'linux/gal_linux_impl.dart';

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
        code: error.code,
        platformException: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> putVideo(String path, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    if (GalLinuxImpl.isLinux) {
      await GalLinuxImpl.putVideo(path);
      return;
    }
    await _invokeMethod<void>('putVideo', {'path': path, 'album': album});
  }

  static Future<void> putImage(String path, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    if (GalLinuxImpl.isLinux) {
      await GalLinuxImpl.putImage(path);
      return;
    }
    await _invokeMethod<void>('putImage', {'path': path, 'album': album});
  }

  static Future<void> putImageBytes(Uint8List bytes, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    if (GalLinuxImpl.isLinux) {
      await GalLinuxImpl.putImageBytes(
        bytes,
        album: album,
      );
      return;
    }
    await _invokeMethod<void>(
      'putImageBytes',
      {'bytes': bytes, 'album': album},
    );
  }

  static Future<void> open() async => _invokeMethod<void>('open', {});

  static Future<bool> hasAccess({bool toAlbum = false}) async {
    if (GalLinuxImpl.isLinux) {
      final result = await GalLinuxImpl.hasAccess(toAlbum: toAlbum);
      return result;
    }
    final hasAccess =
        await _invokeMethod<bool>('hasAccess', {'toAlbum': toAlbum});
    return hasAccess ?? false;
  }

  static Future<bool> requestAccess({bool toAlbum = false}) async {
    if (GalLinuxImpl.isLinux) {
      final result = await GalLinuxImpl.requestAccess(toAlbum: toAlbum);
      return result;
    }
    final granted = await _invokeMethod<bool>(
      'requestAccess',
      {'toAlbum': toAlbum},
    );
    return granted ?? false;
  }
}
