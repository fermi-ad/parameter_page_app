import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

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
  });
}
