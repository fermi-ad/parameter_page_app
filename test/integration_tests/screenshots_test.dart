import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Generate Screenshots', () {
    testWidgets('Display the test parameter page.', (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // Wait 1 second for data to arrive
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Say cheese!
      await binding.takeScreenshot('main-screenshot');
    });
  });
}
