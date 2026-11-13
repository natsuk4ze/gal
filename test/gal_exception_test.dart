import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

void main() {
  for (final type in GalExceptionType.values) {
    test('shows the codes and the message of ${type.name}', () {
      final exception = GalException.fromPlatformException(
        PlatformException(code: type.code, message: 'message'),
        StackTrace.empty,
      );
      expect(
        '$exception',
        '[GalException/${type.code}]: ${type.message} '
            '(PlatformException/${type.code}: message)',
      );
    });
  }
}
