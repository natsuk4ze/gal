import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';

void main() {
  final messenger =
      TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
  const channel = MethodChannel('gal');
  const video = 'example/assets/done.mp4';
  const image = 'example/assets/done.jpg';
  final bytes = File(image).readAsBytesSync();

  test('completes every method', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => true);
    await Gal.putVideo(video);
    await Gal.putImage(image);
    await Gal.putImageBytes(bytes);
    await Gal.open();
    expect(await Gal.hasPermission(), isTrue);
    expect(await Gal.requestPermission(), isTrue);
  });

  test('throws GalException from every method', () async {
    messenger.setMockMethodCallHandler(
      channel,
      (_) => throw PlatformException(code: 'UNEXPECTED'),
    );
    await expectLater(Gal.putVideo(video), throwsA(isA<GalException>()));
    await expectLater(Gal.putImage(image), throwsA(isA<GalException>()));
    await expectLater(Gal.putImageBytes(bytes), throwsA(isA<GalException>()));
    await expectLater(Gal.open(), throwsA(isA<GalException>()));
    await expectLater(Gal.hasPermission(), throwsA(isA<GalException>()));
    await expectLater(Gal.requestPermission(), throwsA(isA<GalException>()));
  });
}
