import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void assertParametersAreOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.byKey(Key("parameter_row_$parameter")), findsOneWidget);
  }
}

void assertParametersAreNotOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.byKey(Key("parameter_row_$parameter")), findsNothing);
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

Future<void> whenIDeleteParameter(tester, String parameter,
    {bool confirm = true}) async {
  await tester.tap(find.byKey(Key("parameter_row_$parameter")));
  await tester.pumpAndSettle();

  if (confirm) {
    await tester.tap(find.text("OK"));
  } else {
    await tester.tap(find.text("Cancel"));
  }

  await tester.pumpAndSettle();
}
