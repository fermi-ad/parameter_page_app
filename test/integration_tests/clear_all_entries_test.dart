import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Clear all Entries', () {
    testWidgets('Clear All button, should not be visible outside edit mode',
        (tester) async {
      // Given the test page is loaded
      //   and I am not in edit mode
      app.main();
      await tester.pumpAndSettle();

      // Then the clear all button is not on the page
      assertClearAllButton(isVisible: false);
    });

    testWidgets('Clear All button, should be visible when in edit mode',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I enter edit mode
      await enterEditMode(tester);

      // Then the clear all button is displayed
      assertClearAllButton(isVisible: true);
    });
  });
}
