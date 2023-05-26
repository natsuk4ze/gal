import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gal_platform_interface.dart';

/// Plugin Communication
class MethodChannelGal extends GalPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('gal');

  /// argument is Map now.
  @override
  Future<void> putVideo(String path) async =>
      methodChannel.invokeMethod<void>('putVideo', {'path': path});
}
