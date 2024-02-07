import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Generate Link to Parameter Page', () {
    testWidgets(
        'For new/un-saved parameter page, copy link menu item is disabled',
        (WidgetTester tester) async {
      // Given I am working on a brand-new, never-persisted parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I open the main menu
      await openMainMenu(tester);

      // Then the "Copy Link" menu item is disabled
      assertMainMenuItem(tester, name: "Copy Link", isEnabled: false);
    }, semanticsEnabled: false);

    testWidgets('For persisted page, copy link menu item is enabled',
        (WidgetTester tester) async {
      // Given I have opened a persisted parameter page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I open the main menu
      await openMainMenu(tester);

      // Then the "Copy Link" menu item is enabled
      assertMainMenuItem(tester, name: "Copy Link", isEnabled: true);
    }, semanticsEnabled: false);

    testWidgets('Persist a new page, copy link menu item switches to enabled',
        (WidgetTester tester) async {
      // Given I have a new parameter page that hasn't been saved yet
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "test copy link");
      await exitEditMode(tester);
      await openMainMenu(tester);
      assertMainMenuItem(tester, name: "Copy Link", isEnabled: false);

      // When I save the page and open the main menu again
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);
      await tester.pumpAndSettle();
      await openMainMenu(tester);

      // Then the "Copy Link" menu item is enabled
      assertMainMenuItem(tester, name: "Copy Link", isEnabled: true);
    }, semanticsEnabled: false);

    testWidgets('Copy link, see confirmation in snack bar',
        (WidgetTester tester) async {
      // Given I am on a persisted page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I tap Copy Link in the menu
      await openMainMenu(tester);
      await tester.tap(find.text("Copy Link"));
      await tester.pump();

      // Then the snack bar is displayed
      assertSnackBar(message: "Page URL copied to clipboard!");

      // ... and the clipboard has been set
      expect(await mockUserDeviceService!.getClipboard() as String,
          contains("/page/4"));
    }, semanticsEnabled: false);
  });
}
