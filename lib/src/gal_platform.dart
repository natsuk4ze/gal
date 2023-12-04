import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _channel = MethodChannel('gal');

abstract class GalPluginPlatform extends PlatformInterface {
  GalPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static GalPluginPlatform _instance = GalPlatformDefault();

  static GalPluginPlatform get instance => _instance;

  static set instance(GalPluginPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> putVideo(String path, {String? album});

  Future<void> putImage(String path, {String? album});

  Future<void> putImageBytes(Uint8List bytes, {String? album});

  Future<void> open();

  Future<bool> hasAccess({bool toAlbum = false});

  Future<bool> requestAccess({bool toAlbum = false});
}

/// Plugin Communication
@immutable
class GalPlatformDefault extends GalPluginPlatform {
  static Future<T?> _invokeMethod<T>(
      String method, Map<String, dynamic> args) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on PlatformException catch (error, stackTrace) {
      throw GalException.fromCode(
          code: error.code, platformException: error, stackTrace: stackTrace);
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
  Future<void> putImageBytes(Uint8List bytes, {String? album}) async {
    await requestAccess(toAlbum: album != null);
    await _invokeMethod<void>(
        'putImageBytes', {'bytes': bytes, 'album': album});
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
