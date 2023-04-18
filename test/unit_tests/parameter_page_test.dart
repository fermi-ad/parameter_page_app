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
  });
}
