import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Sub-system', () {
    testWidgets(
        'Open page with 1 sub-system, sub-system navigation should hidden',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 1
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // Then the sub-system navigation is hidden
      assertSubSystemNavigationIsVisible(false);
    }, semanticsEnabled: false);

    testWidgets(
        'Edit page with 1 sub-system, sub-system navigation should displayed',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // ... and I have opened a page with 1 sub-system
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // When I edit the page
      await enterEditMode(tester);

      // Then the sub-system navigation is shown
      assertSubSystemNavigationIsVisible(true);
    }, semanticsEnabled: false);

    testWidgets(
        'Open Test Page 2, sub-page navigation should show we are on Sub-system 1',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then the sub-system navigation is visible
      assertSubSystemNavigationIsVisible(true);

      // ... and we are currently on Sub-system 1
      assertCurrentSubSystemIs("Sub-system 1");
    }, semanticsEnabled: false);

    testWidgets('Switch sub-system, contents are updated',
        (WidgetTester tester) async {
      // Given I am on Test Page 2 / Sub-system 1
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      assertIsOnPage(comment: "this is comment #1");

      // When I switch to Sub-system 2
      await switchSubSystem(tester, to: "Sub-system 2");

      // Then the current sub-system is...
      assertCurrentSubSystemIs("Sub-system 2");

      // ... and Sub-system 2 / Tab 1 / Sub-page One is displayed
      assertIsOnPage(comment: "this is Sub-system 2 / Tab 1 / Sub-page One");
    });
  });
}
