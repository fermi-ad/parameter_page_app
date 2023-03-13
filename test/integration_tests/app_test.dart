import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;
import 'package:parameter_page/page/page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Smoke Tests', () {
    testWidgets('Enter the parameter page, title is set to Parameter Page',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // Then 'Parameter Page' is displayed in the title bar
      _assertAppBarTitleIs('Parameter Page');
    });
  });

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
        'Display ACNET device with only a reading parameter, should contain parameter details with no setting value',
        (tester) async {
      // Then the descript and reading values should be...
    });
  });
}

void _assertAppBarTitleIs(String titleIs) {
  final appBar = find.byType(AppBar);
  final titleFinder = find.text(titleIs);
  expect(find.descendant(of: appBar, matching: titleFinder), findsOneWidget);
}

void _assertParametersAreOnPage(List<String> parameters) {
  final page = find.byType(PageWidget);
  for (var parameter in parameters) {
    final parameterFinder = find.text(parameter);
    expect(
        find.descendant(of: page, matching: parameterFinder), findsOneWidget);
  }
}
