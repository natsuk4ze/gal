import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gal_method_channel.dart';

abstract class GalPlatform extends PlatformInterface {
  GalPlatform() : super(token: _token);
  static final Object _token = Object();
  static GalPlatform _instance = MethodChannelGal();
  static GalPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GalPlatform] when
  /// they register themselves.
  static set instance(GalPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> putVideo(String path) =>
      throw UnimplementedError('putVideo() has not been implemented.');
}
