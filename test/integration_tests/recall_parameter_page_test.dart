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
  });
}
