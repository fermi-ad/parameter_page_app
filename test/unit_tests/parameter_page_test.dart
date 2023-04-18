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

    test("createEntry with comment, increments length", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I add a comment
      page.createEntry("this is a comment");

      // Then the number of entries is 1
      expect(page.numberOfEntries(), 1);
    });

    test("createEntry, returns the correct type", () {
      // Given an empty ParameterPage
      ParameterPage page = ParameterPage();

      // When I add a new comment...
      PageEntry newEntry = page.createEntry("this is a comment");

      // Then the return type is...
      expect(newEntry, isA<CommentEntry>());
    });
  });
}
