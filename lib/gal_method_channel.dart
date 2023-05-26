import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gal_platform_interface.dart';

class MethodChannelGal extends GalPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('gal');

  @override
  Future<void> putVideo(String path) async =>
      methodChannel.invokeMethod<void>('putVideo', {'path': path});
}
