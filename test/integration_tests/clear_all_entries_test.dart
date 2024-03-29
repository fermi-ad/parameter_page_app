import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Clear all Entries', () {
    testWidgets('Clear All button, should not be visible outside edit mode',
        (tester) async {
      // Given the test page is loaded
      //   and I am not in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // Then the clear all button is not on the page
      assertClearAllButton(isVisible: false);
    });

    testWidgets('Clear All button, should be visible when in edit mode',
        (tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I enter edit mode
      await enterEditMode(tester);

      // Then the clear all button is displayed
      assertClearAllButton(isVisible: true);
    });

    testWidgets('Tap Clear All button, should remove all entries',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I tap the clear all button...
      await clearAll(tester);

      // Then all of the entries are gone
      assertParametersAreNotOnPage(["M:OUTTMP@e,02", "G:AMANDA"]);
    });
  });
}
