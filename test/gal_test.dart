/* import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal/gal_platform_interface.dart';
import 'package:gal/gal_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGalPlatform with MockPlatformInterfaceMixin implements GalPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> putVideo(String path) async =>
      Future.delayed(const Duration(seconds: 2));
}

void main() {
  final GalPlatform initialPlatform = GalPlatform.instance;

  test('$MethodChannelGal is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGal>());
  });

  test('getPlatformVersion', () async {
    Gal galPlugin = Gal();
    MockGalPlatform fakePlatform = MockGalPlatform();
    GalPlatform.instance = fakePlatform;

    expect(await galPlugin.getPlatformVersion(), '42');
  });
}
 */