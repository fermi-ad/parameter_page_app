import 'package:parameter_page/entities/page_entry_factory.dart';
import 'package:test/test.dart';

void main() {
  group('PageEntryFactory unit tests', () {
    test("Input starts with mult:, produces a MultEntry", () {
      // Given a PageEntryFactory
      final factory = PageEntryFactory();

      // When I createEntries(fromInput:) starting with 'mult:'
      final newEntry =
          factory.createEntries(fromInput: "mult:3 mult with 3 parameters")[0];

      // Then the numberOfEntries and description are extracted and placed into the MultEntry
      expect(newEntry.typeAsString, "Mult");
      expect(newEntry.entryText(), "mult:3 mult with 3 parameters");
    });
  });
}
