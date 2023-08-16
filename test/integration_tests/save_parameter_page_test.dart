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
    });
  });
}
