import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Generate Screenshots', () {
    testWidgets('Display the test parameter page.', (tester) async {
      // Given the app is running
      tester.view.physicalSize = const Size(600, 600);
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // Wait 1 second for data to arrive
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Say cheese!
      await binding.takeScreenshot('main-screenshot');
    });
  });
}
