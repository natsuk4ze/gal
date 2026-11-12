import 'package:gal/gal_platform_interface.dart';

final class FakeGalPlatform extends GalPlatform {
  @override
  Future<bool> hasAccess({bool toAlbum = false}) async => true;

  @override
  Future<bool> requestAccess({bool toAlbum = false}) async => true;
}

Future<void> main() async {
  await GalPlatform.instance.hasAccess();
  await GalPlatform.instance.requestAccess(toAlbum: true);
}
