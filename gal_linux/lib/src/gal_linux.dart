import 'dart:typed_data';

// ignore: implementation_imports
import 'package:gal/src/gal_platform.dart';

import 'gal_linux_impl.dart';

class GalPluginLinux extends GalPluginPlatform {
  static void registerWith() {
    GalPluginPlatform.instance = GalPluginLinux();
  }

  @override
  Future<bool> hasAccess({bool toAlbum = false}) =>
      GalLinuxImpl.hasAccess(toAlbum: toAlbum);

  @override
  Future<void> open() => GalLinuxImpl.open();

  @override
  Future<void> putImage(String path, {String? album}) =>
      GalLinuxImpl.putImage(path, album: album);

  @override
  Future<void> putImageBytes(Uint8List bytes, {String? album}) =>
      GalLinuxImpl.putImageBytes(bytes, album: album);

  @override
  Future<void> putVideo(String path, {String? album}) =>
      GalLinuxImpl.putVideo(path, album: album);

  @override
  Future<bool> requestAccess({bool toAlbum = false}) =>
      GalLinuxImpl.requestAccess(toAlbum: toAlbum);
}
