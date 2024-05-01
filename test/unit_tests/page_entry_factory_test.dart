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

    test(
        "Input contains no *, produces a ParameterEntry with a proportion of 1",
        () {
      // Given a PageEntryFactory
      // When I createEntries(fromInput:) with a proportion
      // Then the ParameterEntry has a proportion of 0.5
      _createEntryAndAssertProportion(
          fromInput: "G:MULT1", parameterIs: "G:MULT1", proportionIs: 1);
    });

    test(
        "Input contains * followed by a number, produces a ParameterEntry with a proportion",
        () {
      // Given a PageEntryFactory
      // When I createEntries(fromInput:) with a proportion
      // Then the ParameterEntry has a proportion of 0.5
      _createEntryAndAssertProportion(
          fromInput: "G:MULT1*0.5", parameterIs: "G:MULT1", proportionIs: 0.5);
    });

    test(
        "Input contains * followed by a negative number, produces a ParameterEntry with a negative proportion",
        () {
      // Given a PageEntryFactory
      // When I createEntries(fromInput:) with a proportion
      // Then the ParameterEntry has a proportion of -1
      _createEntryAndAssertProportion(
          fromInput: "G:MULT1*-1", parameterIs: "G:MULT1", proportionIs: -1.0);
    });

    test(
        "Input contains * followed by a positive number with a +, produces a ParameterEntry with a positive proportion",
        () {
      // Given a PageEntryFactory
      // When I createEntries(fromInput:) with a proportion
      // Then the ParameterEntry has a proportion of -1
      _createEntryAndAssertProportion(
          fromInput: "G:MULT1*+2.5", parameterIs: "G:MULT1", proportionIs: 2.5);
    });
  });
}

void _createEntryAndAssertProportion(
    {required String fromInput,
    required String parameterIs,
    required double proportionIs}) {
  final factory = PageEntryFactory();
  final newEntry = factory.createEntries(fromInput: fromInput)[0];
  expect(newEntry.typeAsString, "Parameter");
  expect(newEntry.entryText(), parameterIs);
  expect(newEntry.proportion, proportionIs);
}
