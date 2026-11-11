import 'dart:typed_data';

import 'gal_method_channel.dart';

/// The platform interface of gal.
///
/// `Gal` calls [instance]. Platform implementations and tests extend this
/// class and set [instance] to their own implementation.
/// Methods that are not overridden throw [UnimplementedError].
///
/// See: [PR](https://github.com/natsuk4ze/gal/pull/180)
base class GalPlatform {
  const GalPlatform();

  /// The implementation that `Gal` calls. Defaults to the method channel.
  static GalPlatform instance = MethodChannelGal();

  /// Called by `Gal.putVideo`.
  Future<void> putVideo(String path, {String? album}) =>
      throw UnimplementedError('putVideo() has not been implemented.');

  /// Called by `Gal.putImage`.
  Future<void> putImage(String path, {String? album}) =>
      throw UnimplementedError('putImage() has not been implemented.');

  /// Called by `Gal.putImageBytes`.
  Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    required String name,
  }) => throw UnimplementedError('putImageBytes() has not been implemented.');

  /// Called by `Gal.open`.
  Future<void> open() =>
      throw UnimplementedError('open() has not been implemented.');

  /// Called by `Gal.hasPermission`.
  Future<bool> hasPermission({bool toAlbum = false}) =>
      throw UnimplementedError('hasPermission() has not been implemented.');

  /// Called by `Gal.requestPermission`.
  Future<bool> requestPermission({bool toAlbum = false}) =>
      throw UnimplementedError('requestPermission() has not been implemented.');
}
