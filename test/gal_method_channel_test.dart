import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const channel = MethodChannel('gal');

  test('completes every method', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => true);
    await Gal.putVideo('example/assets/done.mp4');
    await Gal.putImage('example/assets/done.jpg');
    await Gal.putImageBytes(File('example/assets/done.jpg').readAsBytesSync());
    await Gal.open();
    expect(await Gal.hasPermission(), isTrue);
    expect(await Gal.requestPermission(), isTrue);
  });

  test('throws GalException from PlatformException', () {
    messenger.setMockMethodCallHandler(
      channel,
      (_) => throw PlatformException(code: 'UNEXPECTED'),
    );
    return expectLater(Gal.open(), throwsA(isA<GalException>()));
  });
}
