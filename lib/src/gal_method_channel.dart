import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gal_platform_interface.dart';

/// Plugin Communication
final class MethodChannelGal extends GalPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('gal');

  @override
  Future<void> putVideo(String path) async =>
      methodChannel.invokeMethod<void>('putVideo', {'path': path});

  @override
  Future<void> putImage(String path) async =>
      methodChannel.invokeMethod<void>('putImage', {'path': path});

  @override
  Future<void> putImageBytes(Uint8List bytes) async =>
      methodChannel.invokeMethod<void>('putImageBytes', {'bytes': bytes});

  @override
  Future<void> open() async => methodChannel.invokeMethod<void>('open');

  @override
  Future<bool> hasAccess() async {
    final hasAccess = await methodChannel.invokeMethod<bool>('hasAccess');
    return hasAccess ?? false;
  }

  @override
  Future<bool> requestAccess() async {
    final granted = await methodChannel.invokeMethod<bool>('requestAccess');
    return granted ?? false;
  }
}
