import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/page/entry.dart';

void assertIsOnPage({required String comment}) {
  expect(find.text(comment), findsOneWidget);
}

void assertParametersAreOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.text(parameter), findsOneWidget);
  }
}

void assertParametersAreNotOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.text(parameter), findsNothing);
  }
}

void assertParameterHasDetails(String parameter,
    {required String description,
    required String settingValue,
    required String readingValue}) {
  final row = find.byKey(Key("parameter_row_$parameter"));

  final parameterFinder = find.text(parameter);
  expect(find.descendant(of: row, matching: parameterFinder), findsOneWidget);

  final descriptionFinder = find.text(description);
  expect(find.descendant(of: row, matching: descriptionFinder), findsOneWidget);

  final readingValueFinder = find.text(readingValue);
  expect(
      find.descendant(of: row, matching: readingValueFinder), findsOneWidget);

  final settingValueFinder = find.text(settingValue);
  expect(
      find.descendant(of: row, matching: settingValueFinder), findsOneWidget);
}

void assertParameterIsInRow(String parameter, int isInRow) {
  final rowFinder = find.byType(PageEntryWidget);
  final row = rowFinder.evaluate().isEmpty ? null : rowFinder.at(isInRow);

  if (row == null) {
    fail("No parameter found at row #$isInRow");
  }

  expect(
      find.descendant(of: row, matching: find.text(parameter)), findsOneWidget,
      reason:
          "expected $parameter in row $isInRow but something else was there.");
}

Future<void> enterEditMode(tester) async {
  await tester.tap(find.byKey(const Key("enable_edit_mode_button")));
  await tester.pumpAndSettle();
}

Future<void> exitEditMode(tester) async {
  await tester.tap(find.byKey(const Key("enable_edit_mode_button")));
  await tester.pumpAndSettle();
}

Future<void> whenIDeleteParameter(tester, String parameter,
    {bool confirm = true}) async {
  await tester.tap(find.text(parameter));
  await tester.pumpAndSettle();

  if (confirm) {
    await tester.tap(find.text("OK"));
  } else {
    await tester.tap(find.text("Cancel"));
  }

  await tester.pumpAndSettle();
}

Future<void> whenIAddANewComment(tester, String comment) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('add-entry-textfield')), comment);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

Future<void> moveRowAtIndexNRowsUp(tester, int rowIndex, int nRowsUp) async {
  final handlesFinder = find.byIcon(Icons.drag_handle);
  final rowHandleFinder =
      handlesFinder.evaluate().isEmpty ? null : handlesFinder.at(rowIndex);

  if (rowHandleFinder == null) {
    fail("No drag handles found at index $rowIndex.");
  }

  final dragOffset = Offset(0.0, -(nRowsUp * 40.0));
  await tester.drag(rowHandleFinder, dragOffset);
  await tester.pumpAndSettle();
}
