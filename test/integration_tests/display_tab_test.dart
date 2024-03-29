import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Open test page 2, two tabs should be visible', (tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 1
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then two tabs are visible:
      assertTabBarContains(nTabs: 2, withTitles: ["Tab 1", "Tab 2"]);
    }, semanticsEnabled: false);

    testWidgets('Move to Tab 2, parameters for Tab 2 should be visible',
        (tester) async {
      // Given Test Page 2 is loaded...
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // When I switch the tab to Tab 2...
      await switchTab(tester, to: "Tab 2");

      // Then the entries for Tab 1 go away...
      assertIsNotOnPage(comment: "this is comment #1");
      assertIsNotOnPage(comment: "this is comment #2");
      assertParametersAreNotOnPage(["I:BEAM", "R:BEAM"]);

      // ... and the entries for Tab 2 are displayed...
      assertIsOnPage(comment: "This is Tab 2");
    }, semanticsEnabled: false);

    testWidgets(
        'Add parameters to multiple tabs, parameters should appear in correct tabs',
        (WidgetTester tester) async {
      // Given the "Eight Tabs" test page is loaded
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Eight Tabs");

      // ... and I am in edit mode
      await enterEditMode(tester);

      // When I add a new comment to Tab One
      await addANewEntry(tester, "Comment for tab 1");
      await switchTab(tester, to: "Tab Two");
      await addANewEntry(tester, "Comment for tab 2");
      await switchTab(tester, to: "Tab Three");
      await addANewEntry(tester, "Comment for tab 3");
      await switchTab(tester, to: "Tab Four");
      await addANewEntry(tester, "Comment for tab 4");
      await switchTab(tester, to: "Tab Five");
      await addANewEntry(tester, "Comment for tab 5");
      await switchTab(tester, to: "Tab Six");
      await addANewEntry(tester, "Comment for tab 6");
      await switchTab(tester, to: "Tab Seven");
      await addANewEntry(tester, "Comment for tab 7");
      await switchTab(tester, to: "Tab Eight");
      await addANewEntry(tester, "Comment for tab 8");

      // ... and I exit edit mode
      await exitEditMode(tester);

      // Then each tab has the appropriate entries
      assertIsOnPage(comment: "Comment for tab 8");
      await switchTab(tester, to: "Tab Seven");
      assertIsOnPage(comment: "Comment for tab 7");
      await switchTab(tester, to: "Tab Six");
      assertIsOnPage(comment: "Comment for tab 6");
      await switchTab(tester, to: "Tab Five");
      assertIsOnPage(comment: "Comment for tab 5");
      await switchTab(tester, to: "Tab Four");
      assertIsOnPage(comment: "Comment for tab 4");
      await switchTab(tester, to: "Tab Three");
      assertIsOnPage(comment: "Comment for tab 3");
      await switchTab(tester, to: "Tab Two");
      assertIsOnPage(comment: "Comment for tab 2");
      await switchTab(tester, to: "Tab One");
      assertIsOnPage(comment: "This is Tab One");
      assertIsOnPage(comment: "Comment for tab 1");
    }, semanticsEnabled: false);

    testWidgets('Display a page without tabs, tab bar is not visible',
        (WidgetTester tester) async {
      // Given I am on the landing page
      await startParameterPageApp(tester);

      // When I navigate to a page without any tabs
      await navigateToTestPage1(tester);

      // Then the tab bar is not visible
      assertTabBar(isVisible: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Edit a page without tabs, the tab bar and the default Tab 1 is visible',
        (WidgetTester tester) async {
      // Given Test Page 1 is loaded and the tab bar is not visible
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertTabBar(isVisible: false);

      // When I enter edit mode
      await enterEditMode(tester);

      // Then the tab bar is visible
      assertTabBar(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Tap new tab, a tab is created titled Tab 2',
        (WidgetTester tester) async {
      // Given Test Page 1 is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I create a new tab
      await createNewTab(tester);

      // Then a new tab titled Tab 2 is created
      assertTabBarContains(nTabs: 2, withTitles: ["Tab 1", "Tab 2"]);

      // ... and the tab is blank
      assertNumberOfEntriesOnPageIs(0);
    }, semanticsEnabled: false);

    testWidgets('Delete an empty tab, tab is removed',
        (WidgetTester tester) async {
      // Given the "Eight Tabs" test page is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Eight Tabs");
      await enterEditMode(tester);

      // When I delete tab 2
      await deleteTab(tester, withTitle: "Tab Two");

      // Then the tab is removed
      assertTabBarContains(nTabs: 7, withTitles: [
        "Tab One",
        "Tab Three",
        "Tab Four",
        "Tab Five",
        "Tab Six",
        "Tab Seven",
        "Tab Eight"
      ]);
    }, semanticsEnabled: false);

    testWidgets('Only one tab, delete button is hidden',
        (WidgetTester tester) async {
      // Given a new parameter page with 2 tabs
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await createNewTab(tester);

      // When I delete Tab 2, leaving only 1 tab
      await deleteTab(tester, withTitle: "Tab 1");

      // Then the delete button for Tab 1 is hidden
      await openTabEditMenu(tester, forTabWithTitle: "Tab 2");
      assertTabDeleteItem(isVisible: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Attempt to delete a tab with entries, confirmation is displayed',
        (WidgetTester tester) async {
      // Given a new parameter page with 2 tabs
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await createNewTab(tester);

      // ... and tab 2 has one entry
      await switchTab(tester, to: "Tab 2");
      await addANewEntry(
          tester, "user should be prompted before deleting this tab");

      // When I attempt to delete tab 2
      await deleteTab(tester, withTitle: "Tab 2");

      // Then I am prompted to confirm that I want to delete a populated tab
      assertDeleteTabConfirmation(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Cancel delete of tab, tab remains',
        (WidgetTester tester) async {
      // Given a new parameter page with 2 tabs
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await createNewTab(tester);

      // ... and tab 2 has one entry
      await switchTab(tester, to: "Tab 2");
      await addANewEntry(
          tester, "user should be prompted before deleting this tab");

      // When I attempt to delete Tab 2 and answer "Cancel" when prompted
      await deleteTab(tester, withTitle: "Tab 2", confirm: false);

      // Then the tab remains
      assertTabBarContains(nTabs: 2, withTitles: ["Tab 1", "Tab 2"]);
    }, semanticsEnabled: false);

    testWidgets('Confirm delete of tab, tab is removed',
        (WidgetTester tester) async {
      // Given a new parameter page with 2 tabs
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await createNewTab(tester);

      // ... and tab 2 has one entry
      await switchTab(tester, to: "Tab 2");
      await addANewEntry(
          tester, "user should be prompted before deleting this tab");

      // When I attempt to delete Tab 2 and answer "Cancel" when prompted
      await deleteTab(tester, withTitle: "Tab 2", confirm: true);

      // Then the tab remains
      assertTabBarContains(nTabs: 1, withTitles: ["Tab 1"]);
    }, semanticsEnabled: false);

    testWidgets('Rename tab, new title is displayed',
        (WidgetTester tester) async {
      // Given a new parameter page with 1 tab
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I rename the tab...
      await renameTab(tester, withTitle: "Tab 1", to: "A New Title");

      // Then the new title is displayed in the tab bar
      assertTabBarContains(nTabs: 1, withTitles: ["A New Title"]);
    }, semanticsEnabled: false);
  });
}
