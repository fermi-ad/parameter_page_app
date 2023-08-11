import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Recall Parameter Page', () {
    testWidgets('Characterize Add Page Title and Delete Title',
        (WidgetTester tester) async {
      // Given I am on the "Open Parameter Page" page
      //   and there is no page titled 'test add page title'
      app.main();
      await waitForMainPageToLoad(tester);
      await navigateToOpenPage(tester);
      await tester.pumpAndSettle();

      // When I create a new page with the title 'test add page title'
      await addPage(tester, title: "test add page title");

      // Then the page list contains the new title
      assertOpenPageList(containsTitles: ['test add page title']);

      // Clean-up by removing the title
      await deletePage(tester, withTitle: 'test add page title');
    }, semanticsEnabled: false);

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
    }, semanticsEnabled: false);

    testWidgets('Navigate to Open Page, should see a list of saved pages',
        (WidgetTester tester) async {
      // Given the test page is loaded
      app.main();
      await waitForMainPageToLoad(tester);

      // When I navigate to Open Page
      await navigateToOpenPage(tester);

      // Then I should be presented with a list of pages, including...
      assertOpenPage(isVisible: true);
      assertOpenPageList(containsTitles: ['east tower', 'west tower']);
    }, semanticsEnabled: false);

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

      // ... and the page loading progress indicator should be gone
      assertOpeningPageProgressIndicator(isVisible: false);

      // ... and the title should be displayed
      assertPageTitleIs("Test Page 1");

      // ... and the contents of Test Page 1 are loaded
      assertIsOnPage(comment: "this is comment #1");
      assertParametersAreOnPage(["I:BEAM", "R:BEAM"]);
      assertIsOnPage(comment: "this is comment #2");
    });
  });
}
