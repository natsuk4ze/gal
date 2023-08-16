import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  bool toAlbum = false;
  for (var i = 0; i < 2; i++) {
    if (i == 1) {
      execute('Toggle toAlbum');
      toAlbum = true;
    }
    execute('hasAccess(toAlbum: $toAlbum)');
    execute('requestAccess(toAlbum: $toAlbum)');
    execute('putImage(toAlbum: $toAlbum)');
    execute('putImageBytes(toAlbum: $toAlbum)');
    execute('putVideo(toAlbum: $toAlbum)');
  }
  execute('open()');
}

void execute(String key) => testWidgets(key, (tester) async {
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
