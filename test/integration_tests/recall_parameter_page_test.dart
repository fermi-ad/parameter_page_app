import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';

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

    testWidgets(
        'Start a new parameter page then open Test Page 1, show Test Page 1',
        (WidgetTester tester) async {
      // Given I have started a new parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I open Test Page 1
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 1");

      // Then Test Page 1 is open
      assertTestPage1IsOpen();
    });

    testWidgets('Fail to retrieve list of parameter pages, show error',
        (WidgetTester tester) async {
      // Given an error will occur when requesting the list of available parameter pages
      await startParameterPageApp(tester);
      mockParameterPageService!.fetchPagesShouldFail = true;

      // When I attempt to list the available parameter pages to open
      await navigateToOpenPage(tester);

      // Then the error message is displayed
      assertOpenPagesListViewError(
          messageIs:
              "The request for parameter page titles failed, please try again.");
    });

    testWidgets('Fail to retrieve page, show error',
        (WidgetTester tester) async {
      // Given an error will occur when opening Test Page 1
      await startParameterPageApp(tester);
      mockParameterPageService!.fetchPageShouldFail = true;
      await navigateToOpenPage(tester);

      // When I attempt to open the parameter page
      await openParameterPage(tester, withTitle: "Test Page 1");

      // Then the error message is displayed
      assertDisplayPageError(
          messageIs:
              "The request to load the parameter page failed, please try again.");
    });

    testWidgets('Fail to retrieve page entries, show error',
        (WidgetTester tester) async {
      // Given an error will occur when opening Test Page 1
      await startParameterPageApp(tester);
      mockParameterPageService!.fetchEntriesShouldFail = true;
      await navigateToOpenPage(tester);

      // When I attempt to open the parameter page
      await openParameterPage(tester, withTitle: "Test Page 1");

      assertDisplayPageError(
          messageIs:
              "The request to load the parameter page failed, please try again.");
    });
  });
}
