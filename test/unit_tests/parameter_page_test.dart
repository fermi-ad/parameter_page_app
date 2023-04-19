import 'package:parameter_page/page/entry.dart';
import 'package:parameter_page/parameter_page.dart';
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

    test("Add Entry when editing is disabled, throws", () {
      // Given a ParameterPage that is not in edit mode
      ParameterPage page = ParameterPage();

      // When I attempt to add an entry
      // Then an exception is thrown
      expect(() => page.add(CommentEntry("throw when edit mode is disabled")),
          throwsException);
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
      expect(page.numberOfEntries(), 1);
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
  });
}
