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

    testWidgets(
        'Open a page, display selected title with progress indicator while loading',
        (WidgetTester tester) async {
      // Given I am on the Open Page page
      app.main();
      await waitForMainPageToLoad(tester);
      await navigateToOpenPage(tester);

      // When I select Test Page 1
      await openParameterPage(tester, withTitle: 'Test Page 1');

      // Then the new title is displayed immediately
      assertOpenPage(isVisible: false);
      assertPageTitleIs("Test Page 1");

      // ... and a progress indicator is shown while the page is being loaded
      assertIsNotOnPage(comment: "this is comment #1");
      assertOpeningPageProgressIndicator(isVisible: true);
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

      // ... and the title should be displayed
      assertPageTitleIs("Test Page 1");

      // ... and the contents of Test Page 1 are loaded
      assertIsOnPage(comment: "this is comment #1");
      assertParametersAreOnPage(["I:BEAM", "R:BEAM"]);
      assertIsOnPage(comment: "this is comment #2");
    });
  });
}
