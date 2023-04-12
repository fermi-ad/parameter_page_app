import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/page/entry.dart';
import 'package:parameter_page/page/new_entry_editor_widget.dart';

void main() {
  group("NewEntryEditorWidget", () {
    testWidgets('Submit comment, get comment entry',
        (WidgetTester tester) async {
      // Given a new NewEntryEditorWidget
      PageEntry? newEntry;
      final editor = MaterialApp(home: Scaffold(
          body: NewEntryEditorWidget(onSubmitted: (PageEntry submitted) {
        newEntry = submitted;
      })));
      await tester.pumpWidget(editor);

      // when I enter a new comment...
      await tester.enterText(find.byType(TextField), "this is a new comment");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpWidget(editor);

      // Then the returned entry should be a comment
      expect(newEntry, isA<CommentEntry>());
    });

    testWidgets('Submit ACNET device, get ParameterEntry',
        (WidgetTester tester) async {});

    testWidgets(
        'Submit PV, get ParameterEntry', (WidgetTester tester) async {});
  });
}
