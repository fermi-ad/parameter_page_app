import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Display test page, should contain three parameters',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // Then the following parameters should be displayed...
      _assertParametersAreOnPage([
        "M:OUTTMP@e,02",
        "G:AMANDA",
        "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE"
      ]);
    });

    testWidgets(
        'Display ACNET device, should contain parameter details with setting and reading values',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // Then the descript and reading values should be...
      _assertParameterHasDetails("M:OUTTMP@e,02",
          description: "Outdoor temperature",
          settingValue: "50 mm",
          readingValue: "99 mm");
      _assertParameterHasDetails("G:AMANDA",
          description: "Beau's favorite device",
          settingValue: "50 mm",
          readingValue: "99 mm");
    });

    testWidgets(
        "Display PV, should contain parameter details with setting and reading values",
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // Then the description and values should be...
      _assertParameterHasDetails(
          "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
          description: "Example long PV",
          settingValue: "50 mm",
          readingValue: "99 mm");
    });
  });
}

void _assertParametersAreOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.byKey(Key("parameter_row_$parameter")), findsOneWidget);
  }
}

void _assertParameterHasDetails(String parameter,
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
