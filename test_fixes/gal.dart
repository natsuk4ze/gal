import 'package:gal/gal.dart';

Future<void> main() async {
  await Gal.hasAccess();
  await Gal.hasAccess(toAlbum: true);
  await Gal.requestAccess();
  await Gal.requestAccess(toAlbum: true);
}
