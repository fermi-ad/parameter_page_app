import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Recall Parameter Page', () {
    testWidgets(
        'Tap Open Page in main menu, should navigate to the Open Page screen',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await waitForMainPageToLoad(tester);

      // When I navigate to Open Page
      await navigateToOpenPage(tester);

      // Then the user should be presented with the open page screen
      assertOpenPage(isVisible: true);
    });

    testWidgets('Navigate to Open Page, should see a list of saved pages',
        (WidgetTester tester) async {
      // Given the test page is loaded
      app.main();
      await waitForMainPageToLoad(tester);

      // When I navigate to Open Page
      await navigateToOpenPage(tester);

      // Then I should be presented with a list of pages, including...
      assertOpenPageList(containsTitles: ['east tower', 'west tower']);
    });

    testWidgets('Select Test Page 1, return to main page and load Test Page 1',
        (WidgetTester tester) async {
      // Given I am on the "Open Parameter Page" page
      app.main();
      await waitForMainPageToLoad(tester);
      await navigateToOpenPage(tester);

      // When I select Test Page 1
      await openParameterPage(tester, withTitle: 'Test Page 1');

      // Then I should be returned to the main page
      assertOpenPage(isVisible: false);

      // ... and the contents of Test Page 1 are loaded
      assertIsOnPage(comment: "this is comment #1");
      assertIsOnPage(comment: "this is comment #2");
    });
  });
}
