import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create New Parameter Page', () {
    testWidgets('Tap New Page, should be presented with a new blank page',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I press new page and add some new entries
      await newPage(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "A comment");
      await exitEditMode(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, "M:OUTTMP");
      await exitEditMode(tester);

      // Then the page is empty
      assertNumberOfEntriesOnPageIs(2);
      assertParameterIsInRow("M:OUTTMP", 1);
    });

    testWidgets('Tap New Page, should be prompted to throw away recent changes',
        (tester) async {
      // Given the test page is loaded and I have added a new comment but did not save the page yet
      app.main();
      await tester.pumpAndSettle();
      await enterEditMode(tester);
      await addANewComment(tester, "A new comment");
      await exitEditMode(tester);

      // When I press new page
      await newPage(tester);

      // Then I should be prompted to throw away changes
      assertConfirmThrowAwayDialog(isVisible: true);
    });
  });
}
