import 'package:flutter/foundation.dart';
import 'package:gal/src/gal_platform_interface.dart';

/// The platform that `Gal` calls, for mocking `Gal` in tests.
///
/// Implement it with a mock or a fake, and pass it to [install].
/// After that, the static methods of `Gal` call it instead of the real
/// platform.
///
/// ```dart
/// class FakeGal extends Fake implements GalTestPlatform {
///   @override
///   Future<void> putImage(String path, {String? album}) async {}
/// }
///
/// setUp(() => GalTestPlatform.install(FakeGal()));
/// ```
///
/// Methods may be added in minor versions. A fake that implements this
/// class may need to add them, but mocks do not.
@visibleForTesting
abstract interface class GalTestPlatform {
  /// Makes `Gal` call [platform] instead of the real platform.
  @visibleForTesting
  static void install(GalTestPlatform platform) =>
      GalPlatform.instance = _GalTestPlatformAdapter(platform);

  /// Called by `Gal.putVideo`.
  Future<void> putVideo(String path, {String? album});

  /// Called by `Gal.putImage`.
  Future<void> putImage(String path, {String? album});

  /// Called by `Gal.putImageBytes`.
  Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    required String name,
  });

  /// Called by `Gal.open`.
  Future<void> open();

  /// Called by `Gal.hasPermission`.
  Future<bool> hasPermission({bool toAlbum});

  /// Called by `Gal.requestPermission`.
  Future<bool> requestPermission({bool toAlbum});
}

/// Passes the calls from `Gal` to a [GalTestPlatform].
final class _GalTestPlatformAdapter extends GalPlatform {
  const _GalTestPlatformAdapter(this._platform);

  final GalTestPlatform _platform;

  @override
  Future<void> putVideo(String path, {String? album}) =>
      _platform.putVideo(path, album: album);

  @override
  Future<void> putImage(String path, {String? album}) =>
      _platform.putImage(path, album: album);

  @override
  Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    required String name,
  }) => _platform.putImageBytes(bytes, album: album, name: name);

  @override
  Future<void> open() => _platform.open();

  @override
  Future<bool> hasPermission({bool toAlbum = false}) =>
      _platform.hasPermission(toAlbum: toAlbum);

  @override
  Future<bool> requestPermission({bool toAlbum = false}) =>
      _platform.requestPermission(toAlbum: toAlbum);
}
