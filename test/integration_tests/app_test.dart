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

      // Then 'M:OUTTMP' should be displayed
      final page = find.byType(PageWidget);
      final parameterFinder = find.text("G:AMANDA");
      expect(
          find.descendant(of: page, matching: parameterFinder), findsOneWidget);
    });
  });
}

void _assertAppBarTitleIs(String titleIs) {
  final appBar = find.byType(AppBar);
  final titleFinder = find.text(titleIs);
  expect(find.descendant(of: appBar, matching: titleFinder), findsOneWidget);
}
