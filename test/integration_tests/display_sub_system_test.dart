import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

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
    }, semanticsEnabled: false);

    testWidgets('Add sub-system, taken to new sub-system',
        (WidgetTester tester) async {
      // Given I am on a page with 1 sub-system
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // ... and I am in edit mode
      await enterEditMode(tester);

      // When I tap the new sub-system button
      await newSubSystem(tester);

      // Then the current sub-system is
      assertCurrentSubSystemIs("Sub-system 2");

      // ... and the entry list is blank
      assertNumberOfEntriesOnPageIs(0);
    }, semanticsEnabled: false);

    testWidgets('Rename sub-system, changes are reflected in display mode',
        (WidgetTester tester) async {
      // Given I am editing a page
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await enterEditMode(tester);

      // When I change the sub-system title to...
      await changeSubSystemTitle(tester, to: "New Sub-system Title");

      // ... and exit edit mode
      await exitEditMode(tester);

      // Then the new sub-system title is displayed
      assertCurrentSubSystemIs("New Sub-system Title");
    }, semanticsEnabled: false);

    testWidgets(
        'Delete empty sub-system, sub-system is removed without needing confirmation',
        (WidgetTester tester) async {
      // Given I am editing a page with three sub-systems
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await enterEditMode(tester);
      await newSubSystem(tester);

      // When I delete the current sub-system
      await deleteSubSystem(tester);

      // Then Sub-system 3 is removed from the directory
      await openSubSystemDirectory(tester);
      assertSubSystemDirectory(contains: ["Sub-system 1", "Sub-system 2"]);

      // ... and the user is switched to Sub-system 2
      assertCurrentSubSystemIs("Sub-system 2");
    }, semanticsEnabled: false);

    testWidgets(
        'Delete a populated sub-system, sub-system is removed after confirmation',
        (WidgetTester tester) async {
      // Given I am editing a page with 2 sub-systems, the first of which has a sub-page with entries
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await enterEditMode(tester);

      // When I delete the current sub-system and confirm when prompted
      await deleteSubSystem(tester, confirm: true);
      await tester.pumpAndSettle();

      // Then Sub-system 1 is removed from the directory
      await openSubSystemDirectory(tester);
      assertSubSystemDirectory(contains: ["Sub-system 2"]);

      // ... and the user is switched to Sub-system 2
      assertCurrentSubSystemIs("Sub-system 2");

      // ... and that page has 1 entry
      assertNumberOfEntriesOnPageIs(1);
    });
    testWidgets('Cancel sub-system delete, sub-system is not removed',
        (WidgetTester tester) async {
      // Given I am editing a page with 2 sub-systems, the first of which has a sub-page with entries
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");
      await enterEditMode(tester);

      // When I delete the current sub-system but cancel when prompted
      await deleteSubSystem(tester, confirm: false);
      await tester.pumpAndSettle();

      // Then Sub-system 1 is still in the directory
      await openSubSystemDirectory(tester);
      assertSubSystemDirectory(contains: ["Sub-system 1", "Sub-system 2"]);

      // ... and the user is still viewing sub-system 1
      assertCurrentSubSystemIs("Sub-system 1");

      // ... and that page has 4 entries
      assertNumberOfEntriesOnPageIs(4);
    });
  });
}
