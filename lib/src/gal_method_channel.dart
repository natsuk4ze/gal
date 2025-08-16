import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/src/gal_exception.dart';

import 'gal_platform_interface.dart';

/// Plugin Communication
@immutable
final class MethodChannelGal extends GalPlatform {
  final _methodChannel = const MethodChannel('gal');

  Future<T?> _invokeMethod<T>(String method, Map<String, dynamic> args) async {
    try {
      return await _methodChannel.invokeMethod<T>(method, args);
    } on PlatformException catch (error, stackTrace) {
      throw GalException.fromPlatformException(
        code: error.code,
        platformException: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> putVideo(String path, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    await _invokeMethod<void>('putVideo', {'path': path, 'album': album});
  }

  @override
  Future<void> putImage(String path, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    await _invokeMethod<void>('putImage', {'path': path, 'album': album});
  }

  @override
  Future<void> putImageBytes(Uint8List bytes,
      {String? album, required String name}) async {
    await requestAccess(toAlbum: album != null);
    await _invokeMethod<void>(
        'putImageBytes', {'bytes': bytes, 'album': album, 'name': name});
  }

  @override
  Future<void> open() async => _invokeMethod<void>('open', {});

  @override
  Future<bool> hasAccess({bool toAlbum = false}) async {
    final hasAccess =
        await _invokeMethod<bool>('hasAccess', {'toAlbum': toAlbum});
    return hasAccess ?? false;
  }

  @override
  Future<bool> requestAccess({bool toAlbum = false}) async {
    final granted =
        await _invokeMethod<bool>('requestAccess', {'toAlbum': toAlbum});
    return granted ?? false;
  }
}
