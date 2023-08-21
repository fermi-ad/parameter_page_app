import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create New Parameter Page', () {
    testWidgets(
        'Tap Create a New Parameter Page on the landing page, opens a new parameter page',
        (WidgetTester tester) async {
      // Given I am on the landing page
      await startParameterPageApp(tester);

      // When I tap "Create a new Parameter Page"
      await createNewParameterPage(tester);

      // Then the user is given a new parameter page
      assertNumberOfEntriesOnPageIs(0);
      assertPageTitleIs("New Parameter Page");
    });

    testWidgets(
        'Tap New Page and discard changes, should be presented with a new blank page',
        (tester) async {
      // Given the test page is loaded and I have added new parameters
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
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
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForMainPageToLoad(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "A new comment");
      await exitEditMode(tester);

      // When I press new page and cancel when prompted to discard changes
      await newPage(tester, confirmDiscardChanges: false);

      // Then I should be returned to the page
      assertNumberOfEntriesOnPageIs(9);
      assertParameterIsInRow("M:OUTTMP@e,02", 0);
      assertPageTitleIs("Test Page 1");
    });

    testWidgets('Tap New Page, should be prompted to throw away recent changes',
        (tester) async {
      // Given the test page is loaded and I have added a new comment but did not save the page yet
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
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
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
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
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
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

    testWidgets('Tap New Page, persistent state indicator is reset to Clean',
        (tester) async {
      // Given the page I'm working on has been saved
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForMainPageToLoad(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, "I:BEAM");
      await exitEditMode(tester);
      await openMainMenu(tester);
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);
      assertPageSavedIndicator(isVisible: true);

      // When I start a new page
      await newPage(tester);

      // Then the Page Saved indicator goes away
      assertPageSavedIndicator(isVisible: false);
    });
  });
}
