import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:test/test.dart';

void main() {
  group('fetchPages', () {
    test("fetchPages, returns a non-empty list of parameter page titles",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // When I request a list of parameter pages
      List<dynamic> pageTitles = await service.fetchPages();

      // Then at least 2 titles have been returned
      expect(pageTitles.length, greaterThan(1));
    });
  });

  group('fetchPage', () {
    test("fetchPage, returns the correct page structure", () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // When I fetch a test page
      ParameterPage page = await service.fetchPage(id: "1");

      // Then the page title is...
      expect(page.title, "East Booster Towers");

      // ... and the page has 2 sub-systems
      expect(page.subSystemTitles.length, 2);
      expect(page.subSystemTitles[0], "P1 Line M1");
      expect(page.subSystemTitles[1], "P2 Line M2");

      // ... and the first sub-system has 3 tabs
      expect(page.tabTitles.length, 3);
      expect(page.tabTitles[0], "P1 tab #1");
      expect(page.tabTitles[1], "P2 tab #1");
      expect(page.tabTitles[2], "new dev tab");

      // ... and the first tab has 3 sub-pages
      expect(page.subPageDirectory.length, 3);
      expect(page.subPageDirectory[0], "P1 subpage #1");
      expect(page.subPageDirectory[1], "P2 subpage #1");
      expect(page.subPageDirectory[2], "3");

      // ... and Tab 2 has 2 sub-pages
      page.switchTab(to: "P2 tab #1");
      expect(page.subPageDirectory.length, 2);
      expect(page.subPageDirectory[0], "");
      expect(page.subPageDirectory[1], "");

      // ... and Tab 3 has 1 sub-page
      page.switchTab(to: "new dev tab");
      expect(page.subPageDirectory.length, 1);
      expect(page.subPageDirectory[0], "");
    });
  });

  group('createPage', () {
    test(
        "createPage(withTitle:), returns a page ID and the new titles shows up in the directory",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // When I create a new page
      final newPageId =
          await service.createPage(withTitle: "createPage test 1");

      // Then I receive a page ID
      expect(newPageId, isNotNull);

      // ... and the new title shows up in the directory
      List<String> newTitles = await service.fetchPages().then(
          (List<dynamic> pages) =>
              pages.map((page) => page['title'] as String).toList());
      expect(newTitles, contains("createPage test 1"));

      // Clean-up
    });

    test(
        'createPage(withTitle:), creates a blank page with the default structure',
        () async {
      // Given I have used GraphQLParameterPageService to create a new persistent parameter page
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();
      final newPageId =
          await service.createPage(withTitle: "createPage structure test 3");

      // When I read the page back
      ParameterPage readBackPage = await service.fetchPage(id: newPageId);

      // Then the title matches what we requested
      expect(readBackPage.title, "createPage structure test 3");

      // ... and the page has 1 sub-system
      expect(readBackPage.subSystemTitles.length, 1);
      expect(readBackPage.subSystemTitle, "Subsys 1");
      // expect(readBackPage.subSystemTitle, "Sub-system 1");

      // ... and the sub-system has 1 tab
      expect(readBackPage.tabTitles.length, 1);
      expect(readBackPage.tabTitles[0], "Tab 1");

      // ... and the tab has 1 sub-page
      expect(readBackPage.numberOfSubPages, 1);
      expect(readBackPage.subPageTitle, "");

      // Clean-up
    });
  });
}
