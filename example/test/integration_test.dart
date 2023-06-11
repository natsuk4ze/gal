import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gal_example/main.dart' as app;

///All tests are done in integration tests,
///since only integration tests can call native code.
///Other functions take longer to implemen
///because of the possibility of interacting with native dialogs.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('test', () {
    testWidgets('hasAccess() without Exception', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.question_mark);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });

    testWidgets('open() without Exception', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final button = find.byIcon(Icons.open_in_new);
      await tester.tap(button);
      expect(tester.takeException(), isNull);
    });
  });
}
