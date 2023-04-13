import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/page/entry.dart';
import 'package:parameter_page/page/new_entry_editor_widget.dart';

void main() {
  group("NewEntryEditorWidget", () {
    PageEntry? newEntry;

    late MaterialApp editor;

    setUp(() {
      editor = MaterialApp(home: Scaffold(
          body: NewEntryEditorWidget(onSubmitted: (PageEntry submitted) {
        newEntry = submitted;
      })));
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
    });

    testWidgets('Submit ACNET device, get ParameterEntry',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      await tester.pumpWidget(editor);

      // when I enter a new ACNET device...
      // Then the returned entry should be a ParameterEntry
      await createNewEntryAndExpectParameterEntry(tester, "Z:BDCCT");
      await createNewEntryAndExpectParameterEntry(tester, "I:BEAM");
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
