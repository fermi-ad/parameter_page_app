import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:test/test.dart';

void main() {
  group('ParameterPage unit tests', () {
    test("New ParameterPage, entry list is empty", () {
      // When I instantiate a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then the entries list is empty
      expect(page.numberOfEntries, 0);
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
      expect(page.numberOfEntries, initialEntries.length);
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
      expect(page.numberOfEntries, 1);
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
          });

      // When I request the list of entries
      List<PageEntry> entries = page.entriesAsList();

      // Then the list contains the expected entries
      expect(page.id, equals("99"));
      expect(page.title, equals("New Page"));
      expect(entries.length, 3);
      expect(entries[0], isA<CommentEntry>());
      expect(entries[1], isA<CommentEntry>());
      expect(entries[2], isA<ParameterEntry>());
    });

    test("editing(), initially returns false", () {
      // Given nothing
      // When I instantiate a new ParameterPage
      ParameterPage page = ParameterPage();

      // Then edit mode is disabled
      expect(page.editing(), false);
    });

    test("enableEditing(), turns editing mode on", () {
      // Given a new ParameterPage
      ParameterPage page = ParameterPage();

      // When I enableEditing()...
      page.enableEditing();

      // Then edit mode is enabled
      expect(page.editing(), true);
    });

    test("disableEditing(), disables editing mode", () {
      // Given I am editing a ParameterPage
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I disableEditing()
      page.disableEditing();

      // Then edit mode is disabled
      expect(page.editing(), false);
    });

    test("disableEditing(), commits changes to entries list", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I enter editing mode, add an entry, and exit editing mode
      page.enableEditing();
      page.add(CommentEntry("added a new comment"));
      page.disableEditing();

      // Then there is one entry on the page
      expect(page.numberOfEntries, 1);
    });

    test("toggleEditing(), switches from off to on", () {
      // Given an empty ParameterPage with editing mode disabled
      ParameterPage page = ParameterPage();

      // When I toggleEditingMode()
      page.toggleEditing();

      // Then editing mode is enabled
      expect(page.editing(), true);
    });

    test("toggleEditing(), switches from on to off", () {
      // Given an empty ParameterPage with editing mode enabled
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I toggleEditingMode()
      page.toggleEditing();

      // Then editing mode is disabled
      expect(page.editing(), false);
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
      expect(page.editing(), false);
      expect(page.numberOfEntries, 0);
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
      expect(page.numberOfEntries, 0);
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
  });
}
