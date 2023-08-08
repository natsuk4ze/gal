import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gal_platform_interface.dart';

/// Plugin Communication
@immutable
final class MethodChannelGal extends GalPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('gal');

  @override
  Future<void> putVideo(String path, {String? album}) async =>
      methodChannel.invokeMethod<void>('putVideo', {
        'path': path,
        'album': album,
      });

  @override
  Future<void> putImage(String path, {String? album}) async =>
      methodChannel.invokeMethod<void>('putImage', {
        'path': path,
        'album': album,
      });

  @override
  Future<void> putImageBytes(Uint8List bytes, {String? album}) async =>
      methodChannel.invokeMethod<void>('putImageBytes', {
        'bytes': bytes,
        'album': album,
      });

  @override
  Future<void> open() async => methodChannel.invokeMethod<void>('open');

  @override
  Future<bool> hasAccess({bool toAlbum = false}) async {
    final hasAccess = await methodChannel.invokeMethod<bool>('hasAccess', {
      'toAlbum': toAlbum,
    });
    return hasAccess ?? false;
  }

  @override
  Future<bool> requestAccess({bool toAlbum = false}) async {
    final granted = await methodChannel.invokeMethod<bool>('requestAccess', {
      'toAlbum': toAlbum,
    });
    return granted ?? false;
  }
}
