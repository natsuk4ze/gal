import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/main.dart' as app;

/// All tests are done in integration tests,
/// since only integration tests can call native code.
/// Other functions take longer to implement
/// because of the possibility of interacting with native dialogs.
/// For more info: https://github.com/flutter/flutter/wiki/Plugin-Tests
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test', () {
    testWidgets('hasAccess()', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.question_mark);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });

    testWidgets('open()', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.open_in_new);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });

    if (Platform.isIOS) return;

    testWidgets('putVideo()', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.video_file);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });

    testWidgets('putImage()', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.image);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });
  });
}
