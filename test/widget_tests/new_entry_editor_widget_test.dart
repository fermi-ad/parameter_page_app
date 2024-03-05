import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/dpm/mock_dpm_service.dart';
import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/widgets/new_entry_editor_widget.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

void main() {
  group("NewEntryEditorWidget", () {
    late List<PageEntry> newEntries;

    late MaterialApp editor;

    setUp(() {
      editor = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: MockDpmService(),
                  child: NewEntryEditorWidget(
                      onSubmitted: (List<PageEntry> submitted) {
                    newEntries = submitted;
                  }))));
    });

    Future<void> createNewEntry(tester, String newEntryInputText) async {
      await tester.enterText(find.byType(TextField), newEntryInputText);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(editor);
    }

    Future<void> createNewEntryAndExpectParameterEntry(
        tester, String newEntryInputText) async {
      await createNewEntry(tester, newEntryInputText);
      expect(newEntries[0].typeAsString, "Parameter");
    }

    Future<void> createNewEntryAndExpectMultEntry(
        tester, String newEntryInputText) async {
      await createNewEntry(tester, newEntryInputText);
      expect(newEntries[0].typeAsString, "Mult");
    }

    testWidgets('Submit comment, get comment entry',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new comment...
      await createNewEntry(tester, "this is a new comment");

      // Then the returned entry should be a comment
      expect(newEntries[0].typeAsString, "Comments");
      expect(newEntries[0].entryText(), equals("this is a new comment"));
    });

    testWidgets('Submit a hard comment, get comment with bang stripped',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new comment...
      await createNewEntry(tester, "!THIS:IS:A:COMMENT");

      // Then the returned entry should be a comment
      expect(newEntries[0].typeAsString, "Comments");
      expect(newEntries[0].entryText(), equals("THIS:IS:A:COMMENT"));
    });

    testWidgets('Submit ACNET device, get ParameterEntry',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new ACNET device...
      // Then the returned entry should be a ParameterEntry
      await createNewEntryAndExpectParameterEntry(tester, "Z:BDCCT");
      await createNewEntryAndExpectParameterEntry(tester, "I:BEAM");
      await createNewEntryAndExpectParameterEntry(tester, "Z:BDCCT@e,02");
    });

    testWidgets('Submit PV, get ParameterEntry', (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new EPICS PV...
      // Then the returned entry should be a ParameterEntry
      await createNewEntryAndExpectParameterEntry(tester, "EXAMPLE:EPICS:PV");
    });

    testWidgets('Submit Mult, get MultEntry', (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I create a mult entry with mult:n
      // Then the returned entry should be a MultEntry
      await createNewEntryAndExpectMultEntry(tester, "mult:0");
    });
  });
}
