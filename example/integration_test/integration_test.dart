@Timeout(Duration(hours: 1))

import 'dart:io' show Platform;

import 'package:flutter/material.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// ignore: avoid_relative_lib_imports
import 'test_app.dart' as app;

/// All tests are done in integration tests,
/// since only integration tests can call native code.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? group('Android Test', () {
          execute('hasAccess()');
          execute('requestAccess()');
          execute('putImage()');
          execute('putImageBytes()');
          execute('putVideo()');
          execute('open()');
        })
      : group('iOS Test', () {
          execute('hasAccess()');
          execute('open()');

          /// Other functions take longer to implement
          /// because of the possibility of interacting with native dialogs.
          /// For more info: https://github.com/flutter/flutter/wiki/Plugin-Tests
        });
}

void execute(String key) => testWidgets(key, (tester) async {
      await tester.pumpWidget(const app.App());
      await tester.pumpAndSettle();

      final button = find.byKey(Key(key));

      await tester.tap(button);
      await tester.pumpAndSettle();
      if (app.logger.error == null) return;
      fail(
          "${app.logger.error.runtimeType}: ${app.logger.error}\nStackTrace: ${app.logger.stackTrace}");
    });
