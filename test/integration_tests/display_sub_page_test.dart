import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Sub-Page', () {
    testWidgets(
        'Open Test Page 2, sub-page navigation should show we are on sub-page 1 of 2',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then there are 3 sub-pages
      assertNumberOfSubPagesIs(3);

      // ... and the current sub-page is 1
      assertCurrentSubPageIs(1);

      // ... and the sub-page title is "Sub-Page One"
      assertSubPageTitleIs("Sub-Page One");
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2 and switch to Tab 2, sub-page navigation should show we are on sub-page 1 of 1',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and then switch to Tab 2
      await switchTab(tester, to: "Tab 2");

      // Then there is only 1 sub-page
      assertNumberOfSubPagesIs(1);

      // ... and the current sub-page is 1
      assertCurrentSubPageIs(1);

      // ... and the sub-page title is Sub-Page Two
      assertSubPageTitleIs("");
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2 and advance (forward) the sub-page, sub-page navigation should update accordingly',
        (WidgetTester tester) async {
      // Given I have Test Page 2 / Tab 1 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // When I navigate forward to sub-page 2
      await navigateSubPageForward(tester);

      // Then there are still 3 sub-pages
      assertNumberOfSubPagesIs(3);

      // ... and the current sub-page is 2
      assertCurrentSubPageIs(2);

      // ... and the sub-page title is "Sub-Page Two"
      assertSubPageTitleIs("Sub-Page Two");

      // ... and the contents of sub-page 2 are displayed
      assertIsOnPage(comment: "this is comment #3");

      // ... and not the contents of sub-page 1
      assertIsNotOnPage(comment: "this is comment #1");
      assertIsNotOnPage(comment: "this is comment #2");
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2 and decrement (backward) the sub-page, sub-page navigation should update accordingly',
        (WidgetTester tester) async {
      // Given I have Test Page 2 / Tab 1 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I am currently on sub-page 2
      await navigateSubPageForward(tester);
      assertCurrentSubPageIs(2);

      // When I move backwards
      await navigateSubPageBackwards(tester);

      // Then there are still 3 sub-pages
      assertNumberOfSubPagesIs(3);

      // ... and the current sub-page is 1
      assertCurrentSubPageIs(1);

      // ... and the sub-page title is "Sub-Page One"
      assertSubPageTitleIs("Sub-Page One");

      // ... and the contents of sub-page 2 are not displayed
      assertIsNotOnPage(comment: "this is comment #3");

      // ... and the contents of sub-page 1 are
      assertIsOnPage(comment: "this is comment #1");
      assertIsOnPage(comment: "this is comment #2");
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2 and navigate directly to sub-page 2, sub-page navigation updates accordingly',
        (WidgetTester tester) async {
      // Given I have Test Page 2 / Tab 1 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // When I navigate directly to sub-page 2
      await navigateDirectlyToSubpage(tester, withIndex: "2");

      // Then there are still 3 sub-pages
      assertNumberOfSubPagesIs(3);

      // ... and the current sub-page is 2
      assertCurrentSubPageIs(2);

      // ... and the sub-page title is "Sub-Page Two"
      assertSubPageTitleIs("Sub-Page Two");

      // ... and the contents of sub-page 2 are displayed
      assertIsOnPage(comment: "this is comment #3");

      // ... and the contents of sub-page 1 are not
      assertIsNotOnPage(comment: "this is comment #1");
      assertIsNotOnPage(comment: "this is comment #2");
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2 sub-page directory, titles of sub-pages should be displayed',
        (WidgetTester tester) async {
      // Given I have Test Page 2 / Tab 1 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // When I open the sup-page directory
      await openSubPageDirectory(tester);

      // Then the titles for both sub-pages are displayed
      assertSubPageDirectory(contains: ["Sub-Page One", "Sub-Page Two"]);
    }, semanticsEnabled: false);

    testWidgets('Select a sub-page from Directory, taken directly to sub-page',
        (WidgetTester tester) async {
      // Given I have Test Page 2 / Tab 1 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // When I select Sub-Page Two from the Sub-Page Directory
      await navigateSubPageUsingDirectory(tester,
          toSubPageWithTitle: "Sub-Page Two");

      // Then there are still 3 sub-pages
      assertNumberOfSubPagesIs(3);

      // ... and the current sub-page is 2
      assertCurrentSubPageIs(2);

      // ... and the sub-page title is "Sub-Page Two"
      assertSubPageTitleIs("Sub-Page Two");

      // ... and the contents of sub-page 2 are displayed
      assertIsOnPage(comment: "this is comment #3");

      // ... and the contents of sub-page 1 are not
      assertIsNotOnPage(comment: "this is comment #1");
      assertIsNotOnPage(comment: "this is comment #2");
    }, semanticsEnabled: false);

    testWidgets(
        'Delete empty sub-page, sub-page is removed and navigation moves to an adjacent sub-page',
        (WidgetTester tester) async {
      // Given I am on an empty sub-page
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await navigateSubPageForward(tester);
      await navigateSubPageForward(tester);
      await enterEditMode(tester);
      await deleteRow(tester, index: 0);

      // When I delete the current sub-page
      await deleteSubPage(tester);

      // Then the number of sub-pages is decreased
      assertNumberOfSubPagesIs(2);

      // ... and the current sub-page is 2
      assertCurrentSubPageIs(2);
    }, semanticsEnabled: false);

    testWidgets(
        'Attempt to delete a sub-page with entries, confirmation prompt is displayed',
        (WidgetTester tester) async {
      // Given I am on an empty sub-page
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await navigateSubPageForward(tester);
      await navigateSubPageForward(tester);
      await enterEditMode(tester);

      // When I attempt to delete the current sub-page
      await deleteSubPage(tester);

      // Then the confirmation prompt is displayed
      assertDeleteSubPageConfirmation(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Delete a sub-page with entries, sub-page is removed',
        (WidgetTester tester) async {
      // Given I am on Test Page 2, tab 1, sub-page 1
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I am in edit mode
      await enterEditMode(tester);

      // When I attempt to delete the current sub-page
      await deleteSubPage(tester, confirm: true);

      // Then the number of sub-pages is decreased
      assertNumberOfSubPagesIs(2);

      // ... and the current sub-page is 1
      assertCurrentSubPageIs(1);
    }, semanticsEnabled: false);

    testWidgets('Cancel delete sub-page, sub-page is not removed',
        (WidgetTester tester) async {
      // Given I am on Test Page 2, tab 1, sub-page 1
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I am in edit mode
      await enterEditMode(tester);

      // When I attempt to delete the current sub-page
      // ... and I answer 'Cancel' when prompted to confirm
      await deleteSubPage(tester, confirm: false);

      // Then the number of sub-pages is the same
      assertNumberOfSubPagesIs(3);
    }, semanticsEnabled: false);

    testWidgets('Create new sub-page, new sub-page is created and navigated to',
        (WidgetTester tester) async {
      // Given I am on Test Page 2, tab 1, sub-page 1
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I am in editing mode
      await enterEditMode(tester);

      // When I create a new sub-page
      await createNewSubPage(tester);

      // Then the number of sub-pages increases by one
      assertNumberOfSubPagesIs(4);

      // ... and the current sub-page is 4
      assertCurrentSubPageIs(4);

      // ... and the page is empty
      assertNumberOfEntriesOnPageIs(0);
    }, semanticsEnabled: false);

    testWidgets(
        'Change sub-page title, new title reflected outside of edit mode',
        (WidgetTester tester) async {
      // Given I am on Test Page 2, tab 1, sub-page 1
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I am in editing mode
      await enterEditMode(tester);

      // When I change the sub-page title
      await changeSubPageTitle(tester, to: "New Sub-Page One");

      // ... and exit edit mode
      await exitEditMode(tester);

      // Then the sub-page title is updated to reflect the new title
      assertSubPageTitleIs("New Sub-Page One");
    }, semanticsEnabled: false);
  });
}
