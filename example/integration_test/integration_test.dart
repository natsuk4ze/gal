import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart' as app;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 5));

  bool toAlbum = false;
  for (var i = 0; i < 2; i++) {
    if (i == 1) {
      execute('Toggle toAlbum');
      toAlbum = true;
    }
    await execute('hasAccess(toAlbum: $toAlbum)');
    await execute('requestAccess(toAlbum: $toAlbum)');
    await execute('putImage(toAlbum: $toAlbum)');
    await execute('putImageBytes(toAlbum: $toAlbum)');
    await execute('putVideo(toAlbum: $toAlbum)');
  }
  await execute('open()');
}

Future<void> execute(String key) async => testWidgets(key, (tester) async {
      await tester.pumpWidget(const app.App());

      final button = find.byKey(Key(key));

      await tester.tap(button);
      await tester.pumpAndSettle();

      final value = app.logger.value;
      if (value != null) debugPrint('returned: $value');

      if (app.logger.error == null) return;
      fail("""
${app.logger.error.runtimeType}: ${app.logger.error}\n
StackTrace: ${app.logger.stackTrace}
PlatformException: ${app.logger.platformException}""");
    });
