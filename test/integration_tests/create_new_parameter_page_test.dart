import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create New Parameter Page', () {
    testWidgets(
        'Tap New Page and discard changes, should be presented with a new blank page',
        (tester) async {
      // Given the test page is loaded and I have added new parameters
      app.main();
      await waitForMainPageToLoad(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "A comment");
      await exitEditMode(tester);

      // When I press new page and confirm that I want to discard my changes
      await newPage(tester, confirmDiscardChanges: true);

      // Then the changes are discarded and I get a new page
      assertNumberOfEntriesOnPageIs(0);
    });

    testWidgets('Cancel New Page, should preserve the existing page',
        (tester) async {
      // Given the test page is loaded and I have added a new comment but did not save the page yet
      app.main();
      await waitForMainPageToLoad(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "A new comment");
      await exitEditMode(tester);

      // When I press new page and cancel when prompted to discard changes
      await newPage(tester, confirmDiscardChanges: false);

      // Then I should be returned to the page
      assertNumberOfEntriesOnPageIs(9);
      assertParameterIsInRow("M:OUTTMP@e,02", 0);
    });

    testWidgets('Tap New Page, should be prompted to throw away recent changes',
        (tester) async {
      // Given the test page is loaded and I have added a new comment but did not save the page yet
      app.main();
      await waitForMainPageToLoad(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "A new comment");
      await exitEditMode(tester);

      // When I press new page
      await newPage(tester);

      // Then I should be prompted to throw away changes
      assertConfirmThrowAwayDialog(isVisible: true);
    });

    testWidgets('Tap New Page, should not be prompted if there are no changes',
        (tester) async {
      // Given the test page is loaded and I haven't made any changes
      app.main();
      await waitForMainPageToLoad(tester);

      // When I press new page
      await newPage(tester);

      // Then I should not have been prompted
      assertConfirmThrowAwayDialog(isVisible: false);

      // ... and the new page has no entries
      assertNumberOfEntriesOnPageIs(0);

      // ... and the title is...
      assertPageTitleIs("New Parameter Page");
    });

    testWidgets('Tap New Page, should be presented with a new blank page',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await waitForMainPageToLoad(tester);

      // When I press new page and add some new entries
      await newPage(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, "I:BEAM");
      await exitEditMode(tester);

      // Then the page is empty except for the entries I added
      assertNumberOfEntriesOnPageIs(1);
      assertParameterIsInRow("I:BEAM", 0);
    });
  });
}
