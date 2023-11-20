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

      // Then there are 2 sub-pages
      assertNumberOfSubPagesIs(2);

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

      // Then there are still 2 sub-pages
      assertNumberOfSubPagesIs(2);

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

      // Then there are still 2 sub-pages
      assertNumberOfSubPagesIs(2);

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

      // Then there are still 2 sub-pages
      assertNumberOfSubPagesIs(2);

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

      // Then there are still 2 sub-pages
      assertNumberOfSubPagesIs(2);

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
  });
}
