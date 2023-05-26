import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gal_platform_interface.dart';

class Gal {
  static Future<void> putVideo(String path) async => GalPlatform.instance.putVideo(path);

  static Future<void> open() async => Platform.isIOS
      ? launchUrl(Uri.parse("photos-redirect://"))
      : const AndroidIntent(
          action: 'action_view',
          type: 'image/*',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        ).launch();
}
