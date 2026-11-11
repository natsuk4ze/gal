import 'package:flutter/foundation.dart';
import 'package:gal/src/gal_platform_interface.dart';

/// Stands in for `Gal` in tests.
///
/// Implement it with a fake or a mock, and pass it to [setUp].
/// After that, the static methods of `Gal` call it instead of the real
/// platform.
///
/// ```dart
/// class FakeGal extends Fake implements TestGal {
///   @override
///   Future<void> putImage(String path, {String? album}) async {}
/// }
///
/// setUp(() => TestGal.setUp(FakeGal()));
/// ```
///
/// Methods may be added in minor versions. A fake that implements this
/// class may need to add them, but mocks do not.
// This is an interface rather than a subclass of `GalPlatform`, because
// `GalPlatform` is a base class, and mock packages such as mockito can only
// create mocks with `implements`.
@visibleForTesting
abstract interface class TestGal {
  /// Makes `Gal` call [platform] instead of the real platform.
  @visibleForTesting
  static void setUp(TestGal platform) =>
      GalPlatform.instance = _TestGalAdapter(platform);

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

/// Passes the calls from `Gal` to a [TestGal].
final class _TestGalAdapter extends GalPlatform {
  const _TestGalAdapter(this._platform);

  final TestGal _platform;

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
