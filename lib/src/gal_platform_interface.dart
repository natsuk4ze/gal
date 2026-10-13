import 'dart:typed_data';

import 'gal_method_channel.dart';

/// Plugin Platform Interface to to allow Non-endorsed federated plugin
/// See: [PR](https://github.com/natsuk4ze/gal/pull/180)
base class GalPlatform {
  const GalPlatform();
  static GalPlatform instance = MethodChannelGal();

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
  Future<void> putImageBytes(Uint8List bytes,
          {String? album, required String name}) =>
      throw UnimplementedError('putImageBytes() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [open].
  Future<void> open() =>
      throw UnimplementedError('open() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [hasPermission].
  Future<bool> hasPermission({bool toAlbum = false}) =>
      throw UnimplementedError('hasPermission() has not been implemented.');

  /// throw [UnimplementedError] when Plugin [MethodChannelGal] did not
  /// define [requestPermission].
  Future<bool> requestPermission({bool toAlbum = false}) =>
      throw UnimplementedError('requestPermission() has not been implemented.');
}
