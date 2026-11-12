import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/gal_platform_interface.dart';

final class _FakeGalPlatform extends GalPlatform {
  @override
  Future<void> putVideo(String path, {String? album}) async {}

  @override
  Future<void> putImage(String path, {String? album}) async {}

  @override
  Future<void> putImageBytes(
    Uint8List bytes, {
    String? album,
    required String name,
  }) async {}

  @override
  Future<void> open() async {}

  @override
  Future<bool> hasPermission({bool toAlbum = false}) async => true;

  @override
  Future<bool> requestPermission({bool toAlbum = false}) async => true;
}

void main() {
  setUp(() => GalPlatform.instance = _FakeGalPlatform());

  test('putVideo', () => Gal.putVideo('example/assets/done.mp4'));
  test('putImage', () => Gal.putImage('example/assets/done.jpg'));
  test(
    'putImageBytes',
    () => Gal.putImageBytes(File('example/assets/done.jpg').readAsBytesSync()),
  );
  test('open', Gal.open);
  test('hasPermission', Gal.hasPermission);
  test('requestPermission', Gal.requestPermission);

  group('GalException.fromPlatformException', () {
    for (final (code, type) in [
      ('PERMISSION_DENIED', GalExceptionType.permissionDenied),
      ('NOT_ENOUGH_SPACE', GalExceptionType.notEnoughSpace),
      ('NOT_SUPPORTED_FORMAT', GalExceptionType.notSupportedFormat),
      ('UNEXPECTED', GalExceptionType.unexpected),
      ('UNKNOWN', GalExceptionType.unexpected),
    ]) {
      test('$code is ${type.name}', () {
        final exception = GalException.fromPlatformException(
          PlatformException(code: code),
          StackTrace.empty,
        );
        expect(exception.type, type);
      });
    }
  });
}
