import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Open test page 1, one tab should be visible', (tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 1
      await navigateToTestPage1(tester);

      // Then two tabs are visible:
      assertTabBarContains(nTabs: 1, withTitles: ["Tab 1"]);
    });

    testWidgets('Open test page 2, two tabs should be visible', (tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 1
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then two tabs are visible:
      assertTabBarContains(nTabs: 2, withTitles: ["Tab 1", "Tab 2"]);
    });

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
    });

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
      await addANewComment(tester, "Comment for tab 1");
      await switchTab(tester, to: "Tab Two");
      await addANewComment(tester, "Comment for tab 2");
      await switchTab(tester, to: "Tab Three");
      await addANewComment(tester, "Comment for tab 3");
      await switchTab(tester, to: "Tab Four");
      await addANewComment(tester, "Comment for tab 4");
      await switchTab(tester, to: "Tab Five");
      await addANewComment(tester, "Comment for tab 5");
      await switchTab(tester, to: "Tab Six");
      await addANewComment(tester, "Comment for tab 6");
      await switchTab(tester, to: "Tab Seven");
      await addANewComment(tester, "Comment for tab 7");
      await switchTab(tester, to: "Tab Eight");
      await addANewComment(tester, "Comment for tab 8");

      // ... and I exit edit mode
      await exitEditMode(tester);

      // Then each tab has the appropriate entries
      await switchTab(tester, to: "Tab One");
      assertIsOnPage(comment: "This is Tab One");
      assertIsOnPage(comment: "Comment for tab 1");
      await switchTab(tester, to: "Tab Two");
      assertIsOnPage(comment: "Comment for tab 2");
      await switchTab(tester, to: "Tab Three");
      assertIsOnPage(comment: "Comment for tab 3");
      await switchTab(tester, to: "Tab Four");
      assertIsOnPage(comment: "Comment for tab 4");
      await switchTab(tester, to: "Tab Five");
      assertIsOnPage(comment: "Comment for tab 5");
      await switchTab(tester, to: "Tab Six");
      assertIsOnPage(comment: "Comment for tab 6");
      await switchTab(tester, to: "Tab Seven");
      assertIsOnPage(comment: "Comment for tab 7");
      await switchTab(tester, to: "Tab Eight");
      assertIsOnPage(comment: "Comment for tab 8");
    });

    testWidgets('Display a page without tabs, tab bar is not visible',
        (WidgetTester tester) async {
      // Given I am on the landing page
      await startParameterPageApp(tester);

      // When I navigate to a page without any tabs
      await navigateToTestPage1(tester);

      // Then the tab bar is not visible
      assertTabBar(isVisible: false);
    });
  });
}
