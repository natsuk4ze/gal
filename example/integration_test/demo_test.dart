// Plays the demo in the README, which .github/workflows/demo.yml records.
// It taps the example app as a person would, and checks nothing.
//
// The workflow and the demo signal each other: the demo prints lines that
// start with DEMO, and waits for the workflow to create the file demo_go in
// the temporary folder of the app, which it prints, once recording started.
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:gal_example/main.dart';
import 'package:integration_test/integration_test.dart';

/// How the demo shows the saved image. `gallery` taps the snack bar, which
/// opens the gallery app. `explorer` opens the Pictures folder in File
/// Explorer instead, for the Windows Server runners, which have no Photos app.
/// `viewer` leaves it to the workflow, which opens the image in Google Photos,
/// as its gallery asks to sign in on the emulator.
const show = String.fromEnvironment('DEMO_SHOW', defaultValue: 'gallery');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Draws every frame, so that the animations play as they do in the app.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('demo', (tester) async {
    // Only asks for the permission, so that its dialog is answered before
    // the demo is recorded.
    if (Platform.environment.containsKey('DEMO_WARM_UP')) {
      mark('permission ${await Gal.requestPermission()}');
      return;
    }

    WidgetsApp.debugAllowBannerOverride = false;
    await tester.pumpWidget(const App());
    await wait(const Duration(milliseconds: 500));

    final temp = Directory.systemTemp.path;
    mark('ready $temp');
    final go = File('$temp/demo_go');
    for (var i = 0; i < 1200 && !go.existsSync(); i++) {
      await wait(const Duration(milliseconds: 100));
    }
    await wait(const Duration(milliseconds: 1500));

    await tester.tap(find.text('Save Image from file path'));
    await waitFor(find.text('Saved! ✅'));
    await wait(const Duration(milliseconds: 1500));

    if (show == 'explorer') {
      final pictures = '${Platform.environment['USERPROFILE']}\\Pictures';
      await Process.start('explorer.exe', [pictures]);
    } else if (show == 'gallery') {
      await tester.tap(find.text('Gallery ->'));
    }
    mark('gallery');
    // Keeps the app running while the recording goes on.
    await wait(const Duration(seconds: 60));
  });
}

/// Prints a line for the workflow. It also appends the line to the file in
/// DEMO_LOG if it is set, as the output of a desktop app may not reach it.
void mark(String step) {
  final line = 'DEMO: $step';
  debugPrint(line);
  final path = Platform.environment['DEMO_LOG'];
  if (path != null) {
    final file = File(path);
    file.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
  }
}

Future<void> wait(Duration duration) => Future<void>.delayed(duration);

/// Waits until [finder] finds a widget, for up to 30 seconds.
Future<void> waitFor(Finder finder) async {
  for (var i = 0; i < 300 && finder.evaluate().isEmpty; i++) {
    await wait(const Duration(milliseconds: 100));
  }
}
