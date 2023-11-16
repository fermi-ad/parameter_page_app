import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:test/test.dart';

void main() {
  group('ParameterPage unit tests', () {
    test("New ParameterPage, entry list is empty", () {
      // When I instantiate a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then the entries list is empty
      expect(page.numberOfEntries(), 0);
    });

    test("New ParamterPage initialized with entries, numberOfEntries matches",
        () {
      // Given some initial PageEntry objects
      var initialEntries = [
        CommentEntry("a comment"),
        ParameterEntry("M:OUTTMP"),
        ParameterEntry("EPICS:PV")
      ];

      // When I initialize a ParameterPage with the initial entries
      ParameterPage page = ParameterPage(initialEntries);

      // Then the entries size matches the number of parameters passed to the constructor
      expect(page.numberOfEntries(), initialEntries.length);
    });

    test("Modifying ParameterPage when editing is disabled, throws", () {
      // Given a ParameterPage with some entries that is not in edit mode
      ParameterPage page = ParameterPage([
        CommentEntry("row 1"),
        CommentEntry("row 2"),
        CommentEntry("row 3")
      ]);

      // When I attempt to modify the ParameterPage
      // Then an exception is thrown
      expect(() => page.add(CommentEntry("throw when edit mode is disabled")),
          throwsException);
      expect(() => page.removeEntry(at: 0), throwsException);
      expect(() => page.reorderEntry(atIndex: 0, toIndex: 1), throwsException);
      expect(() => page.clearAll(), throwsException);
      expect(() => page.title = "New Title", throwsException);
      expect(() => page.createTab(title: "Tab 2"), throwsException);
    });

    test("Add Entry, increments count", () {
      // Given an empty ParameterPage in editing mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I add a comment
      page.add(CommentEntry("this is a comment"));

      // Then the entries list is 1
      expect(page.numberOfEntries(), 1);
    });

    test("entriesAsList(), returns List of PageEntry objects", () {
      // Given a ParameterPage with two entries
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.add(CommentEntry("this is a comment"));
      page.add(ParameterEntry("M:OUTTMP"));
      page.disableEditing();

      // When I request a list of entries
      List<PageEntry> entries = page.entriesAsList();

      // Then the list contains the two entries
      expect(entries[0], isA<CommentEntry>());
      expect(entries[1], isA<ParameterEntry>());
    });

    test("initialize with query result set, return the proper entries", () {
      // Given a ParameterPage initialized with a graphql query result
      ParameterPage page = ParameterPage.fromQueryResult(
          id: "99",
          title: "New Page",
          queryResult: {
            "tabs": [
              {
                "title": "Tab 1",
                "sub-pages": [
                  {
                    "id": "1",
                    "title": "Sub-Page One",
                    "entries": [
                      {
                        "entryid": "4",
                        "pageid": "3",
                        "position": "0",
                        "text": "this is comment #1",
                        "type": "Comment"
                      },
                      {
                        "entryid": "5",
                        "pageid": "3",
                        "position": "1",
                        "text": "this is comment #2",
                        "type": "Comment"
                      },
                      {
                        "entryid": "6",
                        "pageid": "3",
                        "position": "2",
                        "text": "I:BEAM",
                        "type": "Parameter"
                      }
                    ]
                  }
                ]
              },
              {
                "title": "Tab 2",
                "sub-pages": [
                  {
                    "id": "1",
                    "title": "Sub-Page One",
                    "entries": [
                      {
                        "entryid": "7",
                        "pageid": "3",
                        "position": "0",
                        "text": "R:BEAM",
                        "type": "Parameter"
                      }
                    ]
                  }
                ]
              },
              {
                "title": "Tab 3",
                "sub-pages": [
                  {"id": "1", "title": "", "entries": []}
                ]
              }
            ]
          });

      // When I request the list of entries
      List<PageEntry> entries = page.entriesAsList();
      page.switchTab(to: "Tab 2");
      final tab2Entries = page.entriesAsList();
      page.switchTab(to: "Tab 3");
      final tab3Entries = page.entriesAsList();

      // Then the list contains the expected entries
      expect(page.id, equals("99"));
      expect(page.title, equals("New Page"));
      expect(entries.length, 3);
      expect(entries[0], isA<CommentEntry>());
      expect(entries[1], isA<CommentEntry>());
      expect(entries[2], isA<ParameterEntry>());
      expect(page.tabTitles[0], "Tab 1");
      expect(page.tabTitles[1], "Tab 2");
      expect(tab2Entries.length, 1);
      expect(tab2Entries[0].entryText(), "R:BEAM");
      expect(tab3Entries.length, 0);
    });

    test(
        "fromQueryResult(), should load currentTab with the title from the first tab",
        () {
      // Given a queryResult which contains one tab named "AAA"
      final queryResult = {
        "tabs": [
          {
            "title": "AAA",
            "sub-pages": [
              {
                "id": "1",
                "title": "",
                "entries": [
                  {
                    "entryid": "4",
                    "pageid": "3",
                    "position": "0",
                    "text": "this is comment #1",
                    "type": "Comment"
                  }
                ]
              }
            ]
          }
        ]
      };

      // When I load the query result
      ParameterPage page = ParameterPage.fromQueryResult(
          id: "99", title: "Test Page", queryResult: queryResult);

      // Then currentTab is set to "AAA"
      expect(page.currentTab, "AAA");
    });

    test("editing(), initially returns false", () {
      // Given nothing
      // When I instantiate a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then edit mode is disabled
      expect(page.editing, false);
    });

    test("enableEditing(), turns editing mode on", () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();

      // When I enableEditing()...
      page.enableEditing();

      // Then edit mode is enabled
      expect(page.editing, true);
    });

    test("disableEditing(), disables editing mode", () {
      // Given I am editing a ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I disableEditing()
      page.disableEditing();

      // Then edit mode is disabled
      expect(page.editing, false);
    });

    test("disableEditing(), commits changes to entries list", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I enter editing mode, add an entry, and exit editing mode
      page.enableEditing();
      page.add(CommentEntry("added a new comment"));
      page.disableEditing();

      // Then there is one entry on the page
      expect(page.numberOfEntries(), 1);
    });

    test("toggleEditing(), switches from off to on", () {
      // Given an empty ParameterPage with editing mode disabled
      ParameterPage page = ParameterPage();

      // When I toggleEditingMode()
      page.toggleEditing();

      // Then editing mode is enabled
      expect(page.editing, true);
    });

    test("toggleEditing(), switches from on to off", () {
      // Given an empty ParameterPage with editing mode enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I toggleEditingMode()
      page.toggleEditing();

      // Then editing mode is disabled
      expect(page.editing, false);
    });

    test("cancelEditing(), discards new entries added during editing mode", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I enter editing mode, add two entries, and cancel editing
      page.enableEditing();
      page.add(CommentEntry("comment 1"));
      page.add(CommentEntry("Comment 2"));
      page.cancelEditing();

      // Then editing mode is cancelled, the new entries are discarded and the page is empty
      expect(page.editing, false);
      expect(page.numberOfEntries(), 0);
    });

    test("reorderEntry(..) upwards, moves entry to a new position", () {
      // Given a ParameterPage in edit mode with two comment entries
      ParameterPage page =
          ParameterPage([CommentEntry("comment 1"), CommentEntry("comment 2")]);
      page.enableEditing();

      // When I move entry 1 to position 0
      page.reorderEntry(atIndex: 1, toIndex: 0);

      // Then the entry appears in the new position
      var entries = page.entriesAsList();
      expect(entries[0].entryText(), "comment 2");
      expect(entries[1].entryText(), "comment 1");
    });

    test("reorderEntry(..) downwards, moves entry to a new position", () {
      // Given a ParameterPage in edit mode with two comment entries
      ParameterPage page = ParameterPage([
        CommentEntry("comment 2"),
        CommentEntry("comment 1"),
        CommentEntry("comment 3")
      ]);
      page.enableEditing();

      // When I move entry 1 to position 2
      page.reorderEntry(atIndex: 0, toIndex: 2);

      // Then the entry appears in the new position
      var entries = page.entriesAsList();
      expect(entries[0].entryText(), "comment 1");
      expect(entries[1].entryText(), "comment 2");
      expect(entries[2].entryText(), "comment 3");
    });

    test("removeEntry(at:), removes entry", () {
      // Given a ParameterPage in edit mode with three comment entries
      ParameterPage page = ParameterPage([
        CommentEntry("comment 1"),
        CommentEntry("comment 2"),
        CommentEntry("comment 3")
      ]);
      page.enableEditing();

      // When I remove the second entry
      page.removeEntry(at: 1);

      // Then the entry is removed from the list
      var entries = page.entriesAsList();
      expect(entries[0].entryText(), "comment 1");
      expect(entries[1].entryText(), "comment 3");
    });

    test("clearAll(), removes all entries", () {
      // Given a ParameterPage with three comment entries and edit mode enabled
      ParameterPage page = ParameterPage([
        CommentEntry("comment 1"),
        CommentEntry("comment 2"),
        CommentEntry("comment 3")
      ]);
      page.enableEditing();

      // When I clearAll()
      page.clearAll();

      // Then numberOfEntries is 0
      expect(page.numberOfEntries(), 0);
    });

    test("isDirty(), returns false initially", () {
      // Given a ParameterPage with no changes
      ParameterPage page = ParameterPage([CommentEntry("comment 1")]);

      // Then isDirty() is false
      expect(page.isDirty, false);
    });

    test("add comment, isDirty() returns true", () {
      // Given a ParameterPage with an initial list of entries
      ParameterPage page = ParameterPage([CommentEntry("comment 1")]);
      expect(page.isDirty, false);

      // When I add an entry
      page.toggleEditing();
      page.add(CommentEntry("page should be dirty now"));

      // Then isDirty() is true
      expect(page.isDirty, true);
    });

    test("remove entry, isDirty() return true", () {
      // Givem a ParameterPage with an initial list of entries
      ParameterPage page =
          ParameterPage([CommentEntry("comment 1"), CommentEntry("comment 2")]);

      // When I remove an entry
      page.toggleEditing();
      page.removeEntry(at: 0);

      // Then isDirty() is true
      expect(page.isDirty, true);
    });

    test("add and remove same entry, isDirty() returns false", () {
      // Givem a ParameterPage with an initial list of entries
      ParameterPage page =
          ParameterPage([CommentEntry("comment 1"), CommentEntry("comment 2")]);

      // When I add an entry and then remove the same entry
      page.toggleEditing();
      page.add(CommentEntry("comment 3"));
      page.removeEntry(at: 2);

      // Then isDirty() is true
      expect(page.isDirty, false);
    });

    test("commit changes, isDirty changes to false", () {
      // Given a "dirty" (has uncommited changes) page
      ParameterPage page = ParameterPage([CommentEntry("comment 1")]);
      page.toggleEditing();
      page.add(CommentEntry("comment 2"));
      page.toggleEditing();
      expect(page.isDirty, true);

      // When I commit() the changes
      page.commit();

      // Then isDirty() is false
      expect(page.isDirty, false);
    });

    test("change title, isDirty changes to true", () {
      // Given a page with an initial title
      ParameterPage page = ParameterPage();
      expect(page.title, equals("New Parameter Page"));

      // When I change the page title
      page.toggleEditing();
      page.title = "New Title";
      page.toggleEditing();

      // Then isDirty() is true
      expect(page.isDirty, true);
    });

    test("commit title change, isDirty changes to false", () {
      // Given I have changed the page title and the page is marked dirty
      ParameterPage page = ParameterPage();
      page.toggleEditing();
      page.title = "New title";
      page.toggleEditing();
      expect(page.isDirty, true);

      // When I commit the changes
      page.commit();

      // Then isDirty() returns false
      expect(page.isDirty, false);
    });

    test("cancelEditing(), restores changes to the page title", () {
      // Given I am editing a ParameterPage and have changed the title
      ParameterPage page = ParameterPage();
      page.toggleEditing();
      page.title = "New title";

      // When I cancelEditing()
      page.cancelEditing();

      // Then the original title is restored
      expect(page.title, equals("New Parameter Page"));
    });

    test("A new ParameterPage, should have 1 tab called Tab 1", () {
      // Given nothing...
      // When I create a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then there is one tab named Tab 1
      expect(page.tabTitles.length, 1);
      expect(page.tabTitles[0], "Tab 1");
    });

    test("createTab(title:), makes a new tab", () {
      // Given a new ParameterPage
      // ... and editing mode is enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I createTab(..)...
      page.createTab(title: "Tab 2");

      // Then there are two tabs...
      expect(page.tabTitles.length, 2);
      expect(page.tabTitles[0], "Tab 1");
      expect(page.tabTitles[1], "Tab 2");
    });

    test('createTab(title:), switches currentTab to the new tab', () {
      // Given a new ParameterPage in editing mode with a comment on Tab 1
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.add(CommentEntry("comment #1"));

      // When I createTab()...
      page.createTab();

      // Then currentTab is set to the new tab
      expect(page.currentTab, "Tab 2");

      // ... and entriesAsList() is empty
      expect(page.entriesAsList().length, 0);
    });

    test("createTab(title:), sets the dirty flag", () {
      // Given a new ParameterPage
      // ... and editing is enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I create a new tab...
      page.createTab(title: "Tab 2");

      // Then the page is dirty
      expect(page.isDirty, true, reason: "dirty flag should be true");
    });

    test("cancelEditing(), restores changes to tabs", () {
      // Given I am editing a ParameterPage and have added a new tab
      ParameterPage page = ParameterPage();
      page.toggleEditing();
      page.createTab(title: "Tab 2");

      // When I cancelEditing()
      page.cancelEditing();

      // Then the new tab is discarded
      expect(page.tabTitles.length, 1);
      expect(page.tabTitles[0], "Tab 1");
    });

    test("Initially, currentTab is set to Tab 1", () {
      // Given nothing
      // When I initialize a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then currentTab is...
      expect(page.currentTab, "Tab 1");
    });

    test("switchTab(..), currentTab reflects the new tab", () {
      // Given a ParameterPage with two tabs: Tab 1 and Tab 2
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab(title: "Tab 2");
      page.commit();

      // When I switchTab(..) to Tab 2...
      page.switchTab(to: "Tab 2");

      // Then currentTab is...
      expect(page.currentTab, "Tab 2");
    });

    test("entriesAsList() after switching to a new tab, returns no entries",
        () {
      // Given a ParameterPage
      // ... and Tab 1 has two entries
      ParameterPage page = ParameterPage([
        CommentEntry("This is Tab 1"),
        CommentEntry("Tab 1 has two entries")
      ]);

      // ... and Tab 2 is empty
      page.enableEditing();
      page.createTab(title: "Tab 2");
      page.commit();

      // When I switchTab to Tab 2...
      page.switchTab(to: "Tab 2");

      // Then entriesAsList() returns 0 entries
      final entries = page.entriesAsList();
      expect(entries.length, 0);
    });

    test(
        "add() entries to new tab, entriesAsList() returns new entries for that tab only",
        () {
      // Given a new Parameter Page with one comment on Tab 1
      ParameterPage page = ParameterPage([CommentEntry("This is Tab 1")]);

      // ... and a new tab called Tab 2 has been created...
      page.enableEditing();
      page.createTab(title: "Tab 2");

      // When I add two comments to Tab 2
      page.switchTab(to: "Tab 2");
      page.add(CommentEntry("This is Tab 2"));
      page.add(CommentEntry("And it has two comments"));
      page.commit();

      // Then entriesAsList() returns the new entries
      final entries = page.entriesAsList();
      expect(entries[0].entryText(), "This is Tab 2");
      expect(entries[1].entryText(), "And it has two comments");
      expect(entries.length, 2);

      // ... and Tab 1 still has 1 entry
      page.switchTab(to: "Tab 1");
      final tab1Entries = page.entriesAsList();
      expect(tab1Entries.length, 1);
      expect(tab1Entries[0].entryText(), "This is Tab 1");
    });

    test("switchTab(..) to invalid tab, throws", () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();

      // When I switchTab(..) to a tab that doesn't exist
      // Then an exception is thrown
      expect(() => page.switchTab(to: "bad tab"), throwsException);
    });

    test("entriesAsList(forTab:, subPage:), throws for invalid tab", () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();

      // When I entriesAsList(forTab:) passing an invalid tab title
      // Then an exception is thrown
      expect(() => page.entriesAsListFrom(tab: "Invalid tab", subPage: 1),
          throwsException);
    });

    test(
        "entriesAsList(forTab:, subPage:), returns entries for given tab & sub-page",
        () {
      // Given a ParameterPage populated with entries on two tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.add(CommentEntry("tab 1 comment"));
      page.createTab(title: "Tab Two");
      page.switchTab(to: "Tab Two");
      page.add(CommentEntry("tab 2 comment"));
      page.commit();

      // When I entriesAsList(forTab:)
      final tab1Entries = page.entriesAsListFrom(tab: "Tab 1", subPage: 1);
      final tab2Entries = page.entriesAsListFrom(tab: "Tab Two", subPage: 1);

      // Then I get the entries for the appropriate tab...
      expect(tab1Entries.length, 1);
      expect(tab1Entries[0].entryText(), "tab 1 comment");
      expect(tab2Entries.length, 1);
      expect(tab2Entries[0].entryText(), "tab 2 comment");
    });

    test("createTab() three times, creates new tabs titled Tab N", () {
      // Given a new ParameterPage
      // ... and editing is enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I createTab() three times
      page.createTab();
      page.createTab();
      page.createTab();

      // Then the new tabs are named "Tab N"
      expect(page.tabTitles[1], "Tab 2");
      expect(page.tabTitles[2], "Tab 3");
      expect(page.tabTitles[3], "Tab 4");
    });

    test("deleteTab(title:), deletes the tab identified by title:", () {
      // Given a ParameterPage with two tabs: Tab 1 and Tab 2
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // When I deleteTab()...
      page.deleteTab(title: "Tab 2");

      // Then the tab is removed
      expect(page.tabTitles.length, 1);
      expect(page.tabTitles[0], "Tab 1");
    });

    test("deleteTab(title:), enforces edit mode", () {
      // Given a page with a tab called "Tab 2"
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // ... and the page is no longer in edit mode...
      page.disableEditing();

      // When I deleteTab(..)...
      // Then an exception is thrown
      expect(() => page.deleteTab(title: "Tab 2"), throwsException);
    });

    test("deleteTab(title) called on the only tab, throws an exception", () {
      // Given a page with only one tab that is in edit mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I deleteTab(..)...
      // Then an exception is thrown
      expect(() => page.deleteTab(title: "Tab 1"), throwsException);
    });

    test(
        "deleteTab(title:) on the currentTab, should delete the tab and update currentTab to the next tab in tabTitles",
        () {
      // Given a page with 3 tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();
      page.createTab();

      // ... and the currentTab is Tab 2
      page.switchTab(to: "Tab 2");

      // When I deleteTab(title: "Tab 2")
      page.deleteTab(title: "Tab 2");

      // Then "Tab 2" should be removed...
      expect(page.tabTitles.contains("Tab 2"), false);

      // ... and currentTab should be "Tab 3"
      expect(page.currentTab, "Tab 3");
    });

    test(
        "deleteTab(title:) on the currentTab which is also the last tab, delete the tab and update currentTab to tab before the deleted tab",
        () {
      // Given a page with 2 tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // ... and the current tab is Tab 2
      page.switchTab(to: "Tab 2");

      // When I deleteTab(title: "Tab 2");
      page.deleteTab(title: "Tab 2");

      // Then "Tab 2" should be removed...
      expect(page.tabTitles.contains("Tab 2"), false);

      // ... and currentTab should be "Tab 1"
      expect(page.currentTab, "Tab 1");
    });

    test(
        "numberOfEntries(forTab:), returns the number of entries for the given tab",
        () {
      // Given a ParameterPage with 2 tabs and some entries on tab 1
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.add(CommentEntry("comment #1"));
      page.createTab();

      // When I populate Tab 2 with 2 entries
      page.add(CommentEntry("comment #2"));
      page.add(CommentEntry("comment #3"));

      // ... and switch back to Tab 1
      page.switchTab(to: "Tab 1");

      // Then numberOfEntries(forTab: "Tab 2") should yield 2
      expect(page.numberOfEntries(forTab: "Tab 2"), 2);
    });

    test("renameTab(withTitle:, to:), changes the title of the currentTab", () {
      // Given a ParameterPage with 1 tab named "Tab 1"
      // ... and I am in edit mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I change the title of the current tab
      page.renameTab(withTitle: "Tab 1", to: "New Tab Title");

      // Then the title has been changed
      expect(page.tabTitles.contains("New Tab Title"), true);
      expect(page.tabTitles.contains("Tab 1"), false);

      // ... and currentTab has been updated too
      expect(page.currentTab, "New Tab Title");
    });

    test("renameTab(..), enforces edit mode", () {
      // Given a new parameter page and I am not in edit mode
      ParameterPage page = ParameterPage();

      // When I renameTab(..)...
      // Then an exception is thrown
      expect(() => page.renameTab(withTitle: "Tab 1", to: "Tab 2"),
          throwsException);
    });

    test('renameTab(withTitle:, to:), changes the title of the given tab', () {
      // Given a new ParameterPage with two tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // ... and currentTab is Tab 1
      page.switchTab(to: "Tab 1");

      // When I renameTab(withTitle: "Tab 2", to: "New Tab Title")
      page.renameTab(withTitle: "Tab 2", to: "New Tab Title");

      // Then the title has been changed
      expect(page.tabTitles.contains("New Tab Title"), true,
          reason: "The new title should be present in tabTitles");
      expect(page.tabTitles.contains("Tab 1"), true,
          reason: "Tab 1 should be un-touched");
      expect(page.tabTitles.contains("Tab 2"), false,
          reason: "Tab 2 should have been removed");

      // ... and currentTab is still Tab 1
      expect(page.currentTab, "Tab 1",
          reason: "currentTab should be set to New Tab Title");
    });

    test('renameTab(..), preserves order of tabs', () {
      // Given a new ParameterPage with three tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();
      page.createTab();

      // When I rename Tab 1
      page.renameTab(withTitle: "Tab 1", to: "A New Tab Title");

      // Then the tab is renamed
      expect(page.tabTitles.contains("A New Tab Title"), true);

      // ... and the order of the tabs stays the same
      expect(page.tabTitles[0], "A New Tab Title");
      expect(page.tabTitles[1], "Tab 2");
      expect(page.tabTitles[2], "Tab 3");
    });

    test('tabIndex, returns the index of currentTab in tabTitles', () {
      // Given a new ParameterPage that is being edited
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I create two more tabs
      page.createTab();
      page.createTab();

      // Then currentTabIndex is 2
      expect(page.currentTabIndex, 2);

      // ... and currentTab is Tab 3
      expect(page.currentTab, "Tab 3");
    });

    test('subPageIndex, returns 1 initially', () {
      // Given nothing
      // When I create a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then the subPageIndex is 1
      expect(page.subPageIndex, 1);
    });

    test(
        'incrementSubPage, will not increment subPageIndex if there is only one sub-page',
        () {
      // Given a new ParameterPage with only 1 sub-page
      ParameterPage page = ParameterPage();

      // When I try to incrementSubPage()
      page.incrementSubPage();

      // Then the subPageIndex is still 1
      expect(page.subPageIndex, 1);
    });

    test('decrementSubPageIndex, will not decrease subPageIndex beyond 1', () {
      // Given a new ParameterPage with only 1 sub-page
      ParameterPage page = ParameterPage();

      // When I try to decrementSubPage()
      page.decrementSubPage();

      // Then the subPageIndex is still 1
      expect(page.subPageIndex, 1);
    });

    test('numberOfSubPages, returns 1 initially', () {
      // Given nothing
      // When I create a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then the numberOfSubPages is 1
      expect(page.numberOfSubPages, 1);
    });

    test('createSubPage(), increments the numberOfSubPages by 1', () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I createSubPage()
      page.createSubPage();

      // Then the numberOfSubPages is 2
      expect(page.numberOfSubPages, 2);
    });

    test('createSubPage(), sets subPageIndex to the index of the new sub-page',
        () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I createSubPage()
      page.createSubPage();

      // Then the subPageIndex should be 2
      expect(page.subPageIndex, 2);
    });

    test('createSubPage(), enforces edit mode', () {
      // Given a new ParameterPage that is not in edit mode
      ParameterPage page = ParameterPage();

      // When I createSubPage()
      // Then an exception is thrown
      expect(() => page.createSubPage(), throwsException);
    });

    test('decrementSubPage(), moves subPageIndex backwards', () {
      // Given a ParameterPage with 2 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();

      // When I decrementSubPageIndex()
      page.decrementSubPage();

      // Then subPageIndex is 1
      expect(page.subPageIndex, 1);
    });

    test('incrementSubPage(), moves subPageIndex forward', () {
      // Given a ParameterPage with 2 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();

      // ... and the currentSubPage is 1
      page.decrementSubPage();

      // When I incrementSubPage()
      page.incrementSubPage();

      // Then the subPageIndex is 2
      expect(page.subPageIndex, 2);
    });

    test('add() to a new sub-page, entriesAsList returns appropriate entries',
        () {
      // Given a new ParameterPage with 2 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();

      // When I add entries to sub-page 1
      page.decrementSubPage();
      page.add(CommentEntry("sub-page 1 comment 1"));
      page.add(CommentEntry("sub-page 1 comment 2"));

      // ... and I add entries to sub-page 2
      page.incrementSubPage();
      page.add(CommentEntry("sub-page 2 comment 1"));
      page.add(CommentEntry("sub-page 2 comment 2"));

      // Then entriesAsList() returns the entries for sub-page 1
      page.decrementSubPage();
      final subPage1 = page.entriesAsList();
      expect(subPage1[0].entryText(), "sub-page 1 comment 1");
      expect(subPage1[1].entryText(), "sub-page 1 comment 2");

      // ... and for sub-page 2
      page.incrementSubPage();
      final subPage2 = page.entriesAsList();
      expect(subPage2[0].entryText(), "sub-page 2 comment 1");
      expect(subPage2[1].entryText(), "sub-page 2 comment 2");
    });

    test('subPageIndex, is tracked separately for each tab', () {
      // Given a ParameterPage with two tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // ... and Tab 2 has three sub-pages
      page.createSubPage();
      page.createSubPage();
      expect(page.subPageIndex, 3);

      // When I switch back to Tab 1
      page.switchTab(to: "Tab 1");

      // Then currentSubPage is restored to 1
      expect(page.subPageIndex, 1);
    });

    test('switchTab(to:), remembers subPageIndex', () {
      // Given a ParameterPage with two tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();

      // ... and Tab 2 has three sub-pages
      page.createSubPage();
      page.createSubPage();
      expect(page.subPageIndex, 3);

      // When I switch back Tab 1
      page.switchTab(to: "Tab 1");
      expect(page.subPageIndex, 1);

      // ... and then back to Tab 2
      page.switchTab(to: "Tab 2");

      // Then currentSubPage is restored to 3
      expect(page.subPageIndex, 3);
    });

    test('switchSubPage(to:), switches subPageIndex to n', () {
      // Given a ParameterPage with 1 tab and three sub-pages with entries on sub page 1
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.add(CommentEntry("Tab 1 / Sub-page 1 / Comment 1"));
      page.createSubPage();
      page.createSubPage();

      // When I switchSubPage(to: 1)
      page.switchSubPage(to: 1);

      // Then subPageIndex is 0
      expect(page.subPageIndex, 1);

      // ... and sub-page 1 entries are returned
      final entries = page.entriesAsList();
      expect(entries.length, 1);
      expect(entries[0].entryText(), "Tab 1 / Sub-page 1 / Comment 1");
    });

    test('switchSubPage(to:0), throws', () {
      // Given a new ParameterPage with 1 sub-page
      ParameterPage page = ParameterPage();

      // When I switchSubPage(to:0)
      // Then an exception is thrown
      expect(() => page.switchSubPage(to: 0), throwsException);
    });

    test('switchSubPage(to:) an invalid sub-page, throws', () {
      // Given a ParameterPage with 1 sub-page
      ParameterPage page = ParameterPage();

      // When I switchSubPage(to:) a sub-page that doesn't exist
      // Then an exception is thrown
      expect(() => page.switchSubPage(to: 2), throwsException);
    });

    test(
        'createTab()s and createSubPage()s, produce the correct page structure',
        () {
      // Given a new ParameterPage with 3 tabs
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createTab();
      page.createTab();
      page.createTab();

      // ... and tab 1 has 1 sub-page

      // ... and tab 2 has 2 sub-pages
      page.switchTab(to: "Tab 2");
      page.createSubPage();

      // ... and tab 3 has 3 sub-pages;
      page.switchTab(to: "Tab 3");
      page.createSubPage();
      page.createSubPage();

      // When I populate the page with entries across each tab and sub-page...
      page.switchTab(to: "Tab 1");
      page.add(CommentEntry("Tab 1 / Sub-page 1 / Comment 1"));

      page.switchTab(to: "Tab 2");
      page.switchSubPage(to: 1);
      page.add(CommentEntry("Tab 2 / Sub-page 1 / Comment 1"));
      page.incrementSubPage();
      page.add(CommentEntry("Tab 2 / Sub-page 2 / Comment 1"));

      page.switchTab(to: "Tab 3");
      page.switchSubPage(to: 1);
      page.add(CommentEntry("Tab 3 / Sub-page 1 / Comment 1"));
      page.incrementSubPage();
      page.add(CommentEntry("Tab 3 / Sub-page 2 / Comment 1"));
      page.incrementSubPage();
      page.add(CommentEntry("Tab 3 / Sub-page 3 / Comment 1"));

      // Then the structure is as follows...
      page.switchTab(to: "Tab 1");
      final tab1Sub1 = page.entriesAsList();
      page.switchTab(to: "Tab 2");
      page.switchSubPage(to: 1);
      final tab2Sub1 = page.entriesAsList();
      page.incrementSubPage();
      final tab2Sub2 = page.entriesAsList();
      page.switchTab(to: "Tab 3");
      page.switchSubPage(to: 1);
      final tab3Sub1 = page.entriesAsList();
      page.incrementSubPage();
      final tab3Sub2 = page.entriesAsList();
      page.incrementSubPage();
      final tab3Sub3 = page.entriesAsList();

      expect(tab1Sub1[0].entryText(), "Tab 1 / Sub-page 1 / Comment 1");
      expect(tab2Sub1[0].entryText(), "Tab 2 / Sub-page 1 / Comment 1");
      expect(tab2Sub2[0].entryText(), "Tab 2 / Sub-page 2 / Comment 1");
      expect(tab3Sub1[0].entryText(), "Tab 3 / Sub-page 1 / Comment 1");
      expect(tab3Sub2[0].entryText(), "Tab 3 / Sub-page 2 / Comment 1");
      expect(tab3Sub3[0].entryText(), "Tab 3 / Sub-page 3 / Comment 1");
    });

    test('subPageTitle, is initially empty', () {
      // Given nothing
      // When I create a new ParameterPage with 1 sub-page
      ParameterPage page = ParameterPage();

      // Then the sub page title is empty
      expect(page.subPageTitle, "");
    });

    test('subPageDirectory, is initially all empty titles', () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();

      // When I create three new sub-pages
      page.enableEditing();
      page.createSubPage();
      page.createSubPage();
      page.createSubPage();

      // Then the subPageDirectory contains four empty strings
      final dir = page.subPageDirectory;
      expect(dir.length, 4);
      expect(dir[0], "");
      expect(dir[1], "");
      expect(dir[2], "");
      expect(dir[3], "");
    });

    test('set subPageTitle, enforces edit mode', () {
      // Given a ParameterPage with editing disabled
      ParameterPage page = ParameterPage();

      // When I attempt to set the subPageTitle
      // Then an exception is thrown
      expect(() => page.subPageTitle = "Should Throw", throwsException);
    });

    test('set subPageTitle, change is reflected in subPageDirectory', () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I set the sub page title
      page.subPageTitle = "Sub-page One";

      // Then the new title shows up in subPageDirectory
      expect(page.subPageDirectory[0], "Sub-page One");
    });

    test('changing a subPageTitle, sets the isDirty flag to true', () {
      // Given a new ParameterPage with editing mode turned on
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I change the subPageTitle
      page.subPageTitle = "Sub-page One";

      // Then the isDirty flag is set to true
      expect(page.isDirty, true);
    });

    test(
        'subPageCount(forTab:), returns the number of sub-pages belonging to forTab',
        () {
      // Given a new ParameterPage with edit mode enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // .. and three tabs
      page.createTab();
      page.createTab();

      // When I create a varying number of sub pages for each tab
      page.switchTab(to: "Tab 2");
      page.createSubPage();
      page.switchTab(to: "Tab 3");
      page.createSubPage();
      page.createSubPage();

      // Then subPageCount(forTab: "Tab 1") returns 1
      expect(page.subPageCount(forTab: "Tab 1"), 1);

      // ... and 2 for Tab 2
      expect(page.subPageCount(forTab: "Tab 2"), 2);

      // ... and 3 for Tab 3
      expect(page.subPageCount(forTab: "Tab 3"), 3);
    });
  });
}
