import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gal_platform_interface.dart';

/// Plugin App Facing
class Gal {

  /// Save video to native gallery app
  /// [path] is local path.
  /// not supported [Uri] or something.
  static Future<void> putVideo(String path) async => GalPlatform.instance.putVideo(path);


  /// Save image to native gallery app
  /// [path] is local path.
  /// not supported [Uri] or something.
  static Future<void> putImage(String path) async => GalPlatform.instance.putImage(path);

  /// Open "iOS Photos" when iOS, "Google Photos" when Android. 
  /// iOS is depends on [url_launcher], Android depends on [android_intent_plus].
  static Future<void> open() async => Platform.isIOS
      ? launchUrl(Uri.parse("photos-redirect://"))
      : const AndroidIntent(
          action: 'action_view',
          type: 'image/*',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        ).launch();
}
