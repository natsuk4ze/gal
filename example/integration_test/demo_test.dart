// Plays the demo in the README, which .github/workflows/demo.yml records.
// It taps the example app as a person would, and checks nothing.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal_example/main.dart';
import 'package:integration_test/integration_test.dart';

/// The button that saves the file.
const button = String.fromEnvironment(
  'DEMO_BUTTON',
  defaultValue: 'Save Video from file path',
);

/// How the demo shows the saved file. `gallery` taps the snack bar, which
/// opens the gallery app. `explorer` opens the Pictures folder instead, for
/// the Windows Server runners, which have no Photos app.
const show = String.fromEnvironment('DEMO_SHOW', defaultValue: 'gallery');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Draws every frame, so that the animations play as they do in the app.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('demo', (tester) async {
    WidgetsApp.debugAllowBannerOverride = false;
    await tester.pumpWidget(const App());
    await wait(const Duration(seconds: 2));

    await tester.tap(find.text(button));
    await waitFor(find.text('Saved! ✅'));
    await wait(const Duration(milliseconds: 1500));

    if (show == 'explorer') {
      final pictures = '${Platform.environment['USERPROFILE']}\\Pictures';
      await Process.start('explorer.exe', [pictures]);
    } else {
      await tester.tap(find.text('Gallery ->'));
    }
    // Keeps the app running while the recording goes on.
    await wait(const Duration(seconds: 30));
  });
}

Future<void> wait(Duration duration) => Future<void>.delayed(duration);

/// Waits until [finder] finds a widget, for up to 30 seconds.
Future<void> waitFor(Finder finder) async {
  for (var i = 0; i < 300 && finder.evaluate().isEmpty; i++) {
    await wait(const Duration(milliseconds: 100));
  }
}
