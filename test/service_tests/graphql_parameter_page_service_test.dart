import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
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
    setUpAll(() async => await _deleteAllTestPages());
    // tearDownAll(() async => _deleteAllTestPages());

    test(
        "createPage(withTitle:), returns a page ID and the new titles shows up in the directory",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // When I create a new page
      final newPageId = await service.createPage(
          withTitle: "***SERVICE TEST*** createPage test");

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
      final newPageId = await service.createPage(
          withTitle: "***SERVICE TEST*** createPage structure test 3");

      // When I read the page back
      ParameterPage readBackPage = await service.fetchPage(id: newPageId);

      // Then the title matches what we requested
      expect(
          readBackPage.title, "***SERVICE TEST*** createPage structure test 3");

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

    test(
        'savePage(..) a new ParameterPage with a single sub-page, persists the page properly',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with entries on the default sub-page
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** Save Page Test 3";
      page.add(CommentEntry("test entry #1"));

      // When I save the new page
      final newPageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: newPageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: newPageId);

      // Then the read-back page has the same entries that were persisted
      final entries = readBackPage.entriesAsList();
      expect(entries.length, 1);
      expect(entries[0].entryText(), "test entry #1");

      // Clean-up
    });

    test(
        'savePage(..) an existing ParameterPage with a single sub-page, persists the changes properly',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with entries on the default sub-page
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** Update Persisted Page Test 3";
      page.add(CommentEntry("test entry #1"));
      page.add(CommentEntry("test entry #2"));
      page.add(CommentEntry("test entry #3"));

      // ... that has already been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // ... and I have made changes to the page
      page.removeEntry(at: 2);
      page.removeEntry(at: 1);
      page.removeEntry(at: 0);
      page.add(CommentEntry("the saved page"));
      page.add(CommentEntry("should only have 2 comments now"));

      // When I save the page
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted changes
      final entries = readBackPage.entriesAsList();
      expect(entries.length, 2);
      expect(entries[0].entryText(), "the saved page");
      expect(entries[1].entryText(), "should only have 2 comments now");
    });

    test(
        'savePage(..) a new ParameterPage with multiple sub-pages, persists the changes properly',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three sub-pages each populated with entries
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** Save Multiple Sub-pages Test 3";
      page.add(CommentEntry("test entry on sub-page 1"));
      page.subPageTitle = "Sub Page One";
      page.createSubPage();
      page.add(CommentEntry("test entry on sub-page 2"));
      page.add(CommentEntry("test entry #2 on sub-page 2"));
      page.subPageTitle = "Sub Page Two";
      page.createSubPage();
      page.add(CommentEntry("test entry on sub-page 3"));
      page.add(CommentEntry("test entry #2 on sub-page 3"));
      page.add(CommentEntry("test entry #3 on sub-page 3"));
      page.subPageTitle = "Sub Page Three";

      // When I save the page
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted changes
      List<PageEntry> entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageCount(forTab: "Tab 1"), 3);
      expect(readBackPage.subPageIndex, 1);
      expect(entries.length, 1);
      expect(entries[0].entryText(), "test entry on sub-page 1");
      expect(readBackPage.subPageTitle, "Sub Page One");

      readBackPage.incrementSubPage();
      entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageIndex, 2);
      expect(entries.length, 2);
      expect(entries[0].entryText(), "test entry on sub-page 2");
      expect(entries[1].entryText(), "test entry #2 on sub-page 2");
      expect(readBackPage.subPageTitle, "Sub Page Two");

      readBackPage.incrementSubPage();
      entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageIndex, 3);
      expect(entries.length, 3);
      expect(entries[0].entryText(), "test entry on sub-page 3");
      expect(entries[1].entryText(), "test entry #2 on sub-page 3");
      expect(entries[2].entryText(), "test entry #3 on sub-page 3");
      expect(readBackPage.subPageTitle, "Sub Page Three");
    });

    test(
        'savePage(..) an existing ParameterPage with multiple sub-pages, persists the changes properly',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three sub-pages each populated with entries
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** Save Multiple Sub-pages";
      page.add(CommentEntry("original test entry on sub-page 1"));
      page.subPageTitle = "Sub Page One";
      page.createSubPage();
      page.add(CommentEntry("original test entry on sub-page 2"));
      page.add(CommentEntry("original test entry #2 on sub-page 2"));
      page.subPageTitle = "Sub Page Two";
      page.createSubPage();
      page.add(CommentEntry("original test entry on sub-page 3"));
      page.add(CommentEntry("original test entry #2 on sub-page 3"));
      page.add(CommentEntry("original test entry #3 on sub-page 3"));
      page.subPageTitle = "Sub Page Three";

      // ... and the page has been persisted already
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I make changes to the page
      page.switchSubPage(to: 1);
      page.subPageTitle = "First Sub-page";
      page.removeEntry(at: 0);
      page.add(CommentEntry("new test entry on first sub-page"));
      page.add(CommentEntry("additional test entry on first sub-page"));
      page.switchSubPage(to: 2);
      page.deleteSubPage();
      page.switchSubPage(to: 2);
      page.add(CommentEntry("fourth test entry on sub-page 3"));

      // ... and save them
      await service.savePage(id: pageId, page: page);

      // ... and read the page back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted changes
      List<PageEntry> entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageCount(forTab: "Tab 1"), 2);
      expect(readBackPage.subPageIndex, 1);
      expect(readBackPage.subPageTitle, "First Sub-page");
      expect(entries.length, 2);
      expect(entries[0].entryText(), "new test entry on first sub-page");
      expect(entries[1].entryText(), "additional test entry on first sub-page");

      readBackPage.incrementSubPage();
      entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageIndex, 2);
      expect(readBackPage.subPageTitle, "Sub Page Three");
      expect(entries.length, 4);
      expect(entries[0].entryText(), "original test entry on sub-page 3");
      expect(entries[1].entryText(), "original test entry #2 on sub-page 3");
      expect(entries[2].entryText(), "original test entry #3 on sub-page 3");
      expect(entries[3].entryText(), "fourth test entry on sub-page 3");
    });

    test("savePage(..) a page with multiple tabs, tabs are persisted properly",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with two tabs each populated with entries
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** Save Multiple Tabs Test";
      page.add(CommentEntry("test entry on tab-1 sub-page 1"));
      page.subPageTitle = "Tab 1 Sub 1";
      page.renameTab(withTitle: "Tab 1", to: "First Tab");
      page.createTab();
      page.add(CommentEntry("test entry on tab-2 sub-page 1"));
      page.add(CommentEntry("test entry #2 on tab-2 sub-page 1"));
      page.subPageTitle = "Tab 2 Sub 1";
      page.renameTab(withTitle: "Tab 2", to: "Second Tab");
      page.createSubPage();
      page.add(CommentEntry("test entry #1 on tab-2 sub-page 2"));
      page.add(CommentEntry("test entry #2 on tab-2 sub-page 2"));
      page.subPageTitle = "Tab 2 Sub 2";

      // When I save the page
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted changes
      List<PageEntry> entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageCount(forTab: "First Tab"), 1);
      expect(readBackPage.subPageIndex, 1);
      expect(entries.length, 1);
      expect(entries[0].entryText(), "test entry on tab-1 sub-page 1");
      expect(readBackPage.subPageTitle, "Tab 1 Sub 1");

      readBackPage.switchTab(to: "Second Tab");
      entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageIndex, 1);
      expect(entries.length, 2);
      expect(entries[0].entryText(), "test entry on tab-2 sub-page 1");
      expect(entries[1].entryText(), "test entry #2 on tab-2 sub-page 1");
      expect(readBackPage.subPageTitle, "Tab 2 Sub 1");

      readBackPage.incrementSubPage();
      entries = readBackPage.entriesAsList();
      expect(readBackPage.subPageIndex, 2);
      expect(entries.length, 2);
      expect(entries[0].entryText(), "test entry #1 on tab-2 sub-page 2");
      expect(entries[1].entryText(), "test entry #2 on tab-2 sub-page 2");
      expect(readBackPage.subPageTitle, "Tab 2 Sub 2");
    });

    test("change tab titles and savePage(..), new tab title is persisted",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** update tab titles";
      page.createTab();
      page.createTab();

      // ... and the page has been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I change the tab titles
      page.renameTab(withTitle: "Tab 1", to: "First Tab");
      page.renameTab(withTitle: "Tab 2", to: "Second Tab");
      page.renameTab(withTitle: "Tab 3", to: "Third Tab");

      // ... and save the changes
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted tab title changes
      expect(readBackPage.tabTitles[0], "First Tab");
      expect(readBackPage.tabTitles[1], "Second Tab");
      expect(readBackPage.tabTitles[2], "Third Tab");
    });

    test("renamePage(..), new page title is persisted", () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** original page title";

      // ... and the page has been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I change the page title and save the changes
      page.title = "***SERVICE TEST*** change page title";
      await service.renamePage(id: pageId, newTitle: page.title);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has the persisted page title change
      expect(readBackPage.title, "***SERVICE TEST*** change page title");
    });

    test("delete an empty tab and savePage(..), tab is removed", () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** delete empty tab";
      page.createTab();
      page.createTab();

      // ... and the page has been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I delete a tab
      page.deleteTab(title: "Tab 2");

      // ... and save the changes
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has only 2 tabs
      expect(readBackPage.tabTitles[0], "Tab 1");
      expect(readBackPage.tabTitles[1], "Tab 3");
    });

    test(
        "delete a tab with populated sub-pages and savePage(..), tab is removed",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three tabs populate with sub-pages and entries
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** delete populated tab";
      page.add(CommentEntry("tab 1 sub-page 1 entry 1"));
      page.createTab();
      page.add(CommentEntry("tab 2 sub-page 1 entry 1"));
      page.createSubPage();
      page.add(CommentEntry("tab 2 sub-page 2 entry 1"));
      page.createTab();
      page.add(CommentEntry("tab 3 sub-page 1 entry 1"));

      // ... and the page has been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I delete tab 2
      page.deleteTab(title: "Tab 2");

      // ... and save the changes
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the read-back page has only 2 tabs
      expect(readBackPage.tabTitles[0], "Tab 1");
      expect(readBackPage.tabTitles[1], "Tab 3");
    });

    test("add entries to multiple tabs and savePage(..), changes are persisted",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with three empty tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** add entries to tabs";
      page.createTab();
      page.createTab();

      // ... and the page has been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I add entries to sub-pages on each tab
      page.switchTab(to: "Tab 1");
      page.add(CommentEntry("tab 1 sub-page 1 entry 1"));
      page.switchTab(to: "Tab 2");
      page.add(CommentEntry("tab 2 sub-page 1 entry 1"));
      page.createSubPage();
      page.add(CommentEntry("tab 2 sub-page 2 entry 1"));
      page.switchTab(to: "Tab 3");
      page.add(CommentEntry("tab 3 sub-page 1 entry 1"));

      // ... and save the changes
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the new entries have been persisted
      expect(readBackPage.tabTitles[0], "Tab 1");
      readBackPage.switchTab(to: "Tab 1");
      expect(readBackPage.entriesAsList()[0].entryText(),
          "tab 1 sub-page 1 entry 1");

      expect(readBackPage.tabTitles[1], "Tab 2");
      readBackPage.switchTab(to: "Tab 2");
      expect(readBackPage.entriesAsList()[0].entryText(),
          "tab 2 sub-page 1 entry 1");
      readBackPage.incrementSubPage();
      expect(readBackPage.entriesAsList()[0].entryText(),
          "tab 2 sub-page 2 entry 1");

      expect(readBackPage.tabTitles[2], "Tab 3");
      readBackPage.switchTab(to: "Tab 3");
      expect(readBackPage.entriesAsList()[0].entryText(),
          "tab 3 sub-page 1 entry 1");
    });

    test(
        'savePage(..) a new ParameterPage with multiple sub-systems, sub-systems are persisted',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with two empty sub-systems
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** save multiple sub-systems";
      page.createSubSystem();
      page.subSystemTitle = "New sub-system";

      // When I save the new page
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // ... and read it back
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the new sub-system has been persisted
      final titles = readBackPage.subSystemTitles;
      expect(titles.length, 2);
      expect(titles[1], "New sub-system");
    });

    test(
        'modify a persisted ParameterPage with multiple sub-systems, changes are persisted',
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // ... and a new ParameterPage with two populated sub-systems
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.title = "***SERVICE TEST*** update multiple sub-systems";
      page.subSystemTitle = "First subsys";
      page.createSubSystem();
      page.subSystemTitle = "Second subsys";

      // ... and the page has already been persisted
      final pageId = await service.createPage(withTitle: page.title);
      await service.savePage(id: pageId, page: page);

      // When I make changes to the page
      page.subSystemTitle = "2nd Sub-system";
      page.switchSubSystem(to: "First subsys");
      page.subSystemTitle = "1st Sub-system";

      // ... and save the changes
      await service.savePage(id: pageId, page: page);

      // ... and read back the page
      ParameterPage readBackPage = await service.fetchPage(id: pageId);

      // Then the changes to sub-system 1 and sub-system 2 have been persisted
      final subSystemTitles = readBackPage.subSystemTitles;
      expect(subSystemTitles.length, 2);
      expect(subSystemTitles[0], "1st Sub-system");
      expect(subSystemTitles[1], "2nd Sub-system");
    });

    test('delete empty sub-system and savePage(..), changes are persisted',
        () async {});
  });
}

Future<void> _deleteAllTestPages() async {
  await dotenv.load(fileName: ".env");
  final service = GraphQLParameterPageService();

  final pageIdsToDelete = await _findTestPageIds(using: service);
  if (pageIdsToDelete.isNotEmpty) {
    await _deletePages(using: service, pageIds: pageIdsToDelete);
  }
}

Future<List<String>> _findTestPageIds(
    {required ParameterPageService using}) async {
  final allPages = await using.fetchPages();

  List<String> ret = [];
  for (final page in allPages) {
    final String pageTitle = page['title'] as String;
    if (pageTitle.contains('***SERVICE TEST***')) {
      ret.add(page['pageid']!);
    }
  }

  return ret;
}

Future<void> _deletePages(
    {required ParameterPageService using,
    required List<String> pageIds}) async {
  for (final id in pageIds) {
    await using.deletePage(withPageId: id);
  }
}
