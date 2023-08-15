import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Recall Parameter Page', () {
    testWidgets('Start app fresh, display the landing page',
        (WidgetTester tester) async {
      // Given nothing
      // When I start the application fresh
      await startParameterPageApp(tester);

      // Then I should the landing page
      assertLandingPage(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Load Test Page 1 from Landing Page, display Test Page 1',
        (WidgetTester tester) async {
      // Given I am on the Landing Page
      await startParameterPageApp(tester);

      // When I tap Open a Parameter Page and select Test Page 1
      await navigateToTestPage1(tester);

      // Then Test Page 1 should be displayed
      assertTestPage1IsOpen();
    }, semanticsEnabled: false);

    testWidgets('Characterize Add Page Title and Delete Title',
        (WidgetTester tester) async {
      // Given I am on the "Open Parameter Page" page
      //   and there is no page titled 'test add page title'
      await startParameterPageApp(tester);
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
      // Given the application is started fresh
      await startParameterPageApp(tester);

      // When I navigate to Open Page
      await navigateToOpenPage(tester);

      // Then the user should be presented with the open page screen
      assertOpenPage(isVisible: true);
    }, semanticsEnabled: false);

    testWidgets('Navigate to Open Page, should see a list of saved pages',
        (WidgetTester tester) async {
      // Given the application is started fresh
      await startParameterPageApp(tester);

      // When I navigate to Open Page
      await navigateToOpenPage(tester);

      // Then I should be presented with a list of pages, including...
      assertOpenPage(isVisible: true);
      assertOpenPageList(containsTitles: ['east tower', 'west tower']);
    }, semanticsEnabled: false);

    testWidgets('Select Test Page 1, return to main page and load Test Page 1',
        (WidgetTester tester) async {
      // Given I am on the "Open Parameter Page" page
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);

      // When I select Test Page 1
      await openParameterPage(tester, withTitle: 'Test Page 1');

      // Then I should be returned to the main page
      assertOpenPage(isVisible: false);

      // ... and the page loading progress indicator should be gone
      assertOpeningPageProgressIndicator(isVisible: false);

      // ... and Test Page 1 is open
      assertTestPage1IsOpen();
    }, semanticsEnabled: false);

    testWidgets('Select Test Page 2, return to main page and load Test Page 2',
        (WidgetTester tester) async {
      // Given I am on the "Open Parameter Page" page
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);

      // When I select Test Page 1
      await openParameterPage(tester, withTitle: 'Test Page 2');

      // Then I should be returned to the main page
      assertOpenPage(isVisible: false);

      // ... and the page loading progress indicator should be gone
      assertOpeningPageProgressIndicator(isVisible: false);

      // ... and the title should be displayed
      assertPageTitleIs("Test Page 2");

      // ... and the contents of Test Page 1 are loaded
      assertIsOnPage(comment: "this is comment #1");
      assertParametersAreOnPage(["I:BEAM", "R:BEAM"]);
      assertIsOnPage(comment: "this is comment #2");
    }, semanticsEnabled: false);

    testWidgets('Open Test Page 2 and then open Test Page 1, show test page 1',
        (WidgetTester tester) async {
      // Given I have Test Page 2 open
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: 'Test Page 2');
      assertPageTitleIs("Test Page 2");

      // When I open Test Page 1
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // Then Test Page 1 is open
      assertTestPage1IsOpen();
    }, semanticsEnabled: false);
  });
}
