import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/gal_platform_interface.dart';

final class _FakeGalPlatform extends GalPlatform {}

void main() {
  setUp(() => GalPlatform.instance = _FakeGalPlatform());

  test('throws UnimplementedError without overrides', () async {
    const video = 'example/assets/done.mp4';
    const image = 'example/assets/done.jpg';
    final bytes = File(image).readAsBytesSync();
    await expectLater(Gal.putVideo(video), throwsUnimplementedError);
    await expectLater(Gal.putImage(image), throwsUnimplementedError);
    await expectLater(Gal.putImageBytes(bytes), throwsUnimplementedError);
    await expectLater(Gal.open(), throwsUnimplementedError);
    await expectLater(Gal.hasPermission(), throwsUnimplementedError);
    await expectLater(Gal.requestPermission(), throwsUnimplementedError);
  });

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
          PlatformException(code: code, message: 'message'),
          StackTrace.empty,
        );
        expect(exception.type, type);
        expect(
          '$exception',
          '[GalException/${type.code}]: ${type.message} '
              '(PlatformException/$code: message)',
        );
      });
    }
  });
}
