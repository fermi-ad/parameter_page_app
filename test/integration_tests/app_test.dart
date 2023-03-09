import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parameter Page End-to-End Tests', () {
    testWidgets('Enter the parameter page, title is set to Parameter Page',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // Then 'Parameter Page' is displayed in the title bar
      _assertAppBarTitleIs('Parameter Page');
    });
  });
}

void _assertAppBarTitleIs(String titleIs) {
  final appBar = find.byType(AppBar);
  final titleFinder = find.text(titleIs);
  expect(find.descendant(of: appBar, matching: titleFinder), findsOneWidget);
}
