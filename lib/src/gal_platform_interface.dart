import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gal_method_channel.dart';

/// Plugin Platform Interface
abstract class GalPlatform extends PlatformInterface {
  GalPlatform() : super(token: _token);
  static final Object _token = Object();
  static GalPlatform _instance = MethodChannelGal();
  static GalPlatform get instance => _instance;

  static set instance(GalPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [putVideo].
  Future<void> putVideo(String path, {String? album}) =>
      throw UnimplementedError('putVideo() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [putImage].
  Future<void> putImage(String path, {String? album}) =>
      throw UnimplementedError('putImage() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [putImageBytes].
  Future<void> putImageBytes(Uint8List bytes, {String? album}) =>
      throw UnimplementedError('putImageBytes() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [open].
  Future<void> open() =>
      throw UnimplementedError('open() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [hasAccess].
  Future<bool> hasAccess({bool toAlbum = false}) =>
      throw UnimplementedError('hasAccess() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [requestAccess].
  Future<bool> requestAccess({bool toAlbum = false}) =>
      throw UnimplementedError('requestAccess() has not been implemented.');
}