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

    test("Add Entry, increments count", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I add a comment
      page.add(CommentEntry("this is a comment"));

      // Then the entries list is 1
      expect(page.numberOfEntries(), 1);
    });

    test("entriesAsList(), returns List of PageEntry objects", () {
      // Given a ParameterPage with two entries
      ParameterPage page = ParameterPage();
      page.add(CommentEntry("this is a comment"));
      page.add(ParameterEntry("M:OUTTMP"));

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
  });
}
