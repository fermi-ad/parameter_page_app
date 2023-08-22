import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Save Parameter Page', () {
    testWidgets('Modify page, show un-saved changes indicator',
        (WidgetTester tester) async {
      // Given the test page is loaded and the un-saved changes indicator is not visible
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertUnsavedChangesIndicator(isVisible: false);

      // When I modify the page
      await enterEditMode(tester);
      await addANewParameter(tester, 'Z:BDCCT');
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "Z:BDCCT");

      // Then the "Un-saved Changes" indicator is displayed
      assertUnsavedChangesIndicator(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Modify page, save command is enabled in menu',
        (WidgetTester tester) async {
      // Given the test page is loaded and the Save menu item is disabled
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await openMainMenu(tester);
      assertMainMenuItem(tester, name: "Save", isEnabled: false);
      await closeMainMenu(tester);

      // When I modify the page
      await enterEditMode(tester);
      await addANewParameter(tester, 'Z:BDCCT');
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "Z:BDCCT");

      // Then the menu item becomes enabled
      await openMainMenu(tester);
      assertMainMenuItem(tester, name: "Save", isEnabled: true);
    }, semanticsEnabled: false);

    testWidgets('Save page, saving/saved indicator is shown',
        (WidgetTester tester) async {
      // Given there are unsaved changes to the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, 'Z:BDCCT');
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "Z:BDCCT");
      assertUnsavedChangesIndicator(isVisible: true);

      // When I save the page
      await openMainMenu(tester);
      await saveParameterPage(tester);

      // Then the saving page indicator is displayed for three seconds
      assertSavingPageIndicator(isVisible: true);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ... and then it changes to the Page Saved indicator
      assertSavingPageIndicator(isVisible: false);
      assertPageSavedIndicator(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Save existing page, changes persist',
        (WidgetTester tester) async {
      // Given I have modified Test Page 1 by adding a new comment and saved it
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "a new comment");
      await exitEditMode(tester);
      await openMainMenu(tester);
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);

      // When I open a different page
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and then open the saved paged
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // Then the new comment has persisted
      assertIsOnPage(comment: "a new comment");
    }, semanticsEnabled: false);

    testWidgets('Save new page, changes persist', (WidgetTester tester) async {
      // Given I've created and saved a new parameter page called 'New Parameter Page'
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await enterEditMode(tester);
      await addANewComment(tester, "this is a new page");
      await exitEditMode(tester);
      await openMainMenu(tester);
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);

      // When I open a different page
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and then open the saved paged
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "New Parameter Page");

      // Then the new page has persisted
      assertIsOnPage(comment: "this is a new page");
    }, semanticsEnabled: false);

    testWidgets(
        'Change page title, page persistence indicator changes to unsaved',
        (WidgetTester tester) async {
      // Given I've loaded Test Page 1 and I have entered edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I change the page title and exit edit mode
      await changePageTitle(tester, to: "My New Page");
      await exitEditMode(tester);

      // Then the "Un-saved Changes" indicator is displayed
      assertUnsavedChangesIndicator(isVisible: true);

      // ... and the new title is shown
      assertPageTitleIs("My New Page");
    });
  });
}
