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
      expect(find.text('Parameter Page'), findsOneWidget);
    });

    testWidgets('tap increment button, counter increments by 1',
        (tester) async {
      // Given the application is running and the counter displayed is 0
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      // When I tap the increment button
      final Finder fab = find.byTooltip('Increment');
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Then the counter shows...
      expect(find.text('1'), findsOneWidget);
    });
  });
}
