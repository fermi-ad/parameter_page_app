import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/mock-dpm/mock_dpm_service.dart';
import 'package:parameter_page/page_entry.dart';
import 'package:parameter_page/widgets/new_entry_editor_widget.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

void main() {
  group("NewEntryEditorWidget", () {
    late PageEntry newEntry;

    late MaterialApp editor;

    setUp(() {
      editor = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: const MockDpmService(),
                  child:
                      NewEntryEditorWidget(onSubmitted: (PageEntry submitted) {
                    newEntry = submitted;
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
      expect(newEntry, isA<ParameterEntry>());
    }

    testWidgets('Submit comment, get comment entry',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new comment...
      await createNewEntry(tester, "this is a new comment");

      // Then the returned entry should be a comment
      expect(newEntry, isA<CommentEntry>());
      expect(newEntry.entryText(), equals("this is a new comment"));
    });

    testWidgets('Submit a hard comment, get comment with bang stripped',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new comment...
      await createNewEntry(tester, "!THIS:IS:A:COMMENT");

      // Then the returned entry should be a comment
      expect(newEntry, isA<CommentEntry>());
      expect(newEntry.entryText(), equals("THIS:IS:A:COMMENT"));
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
  });
}
