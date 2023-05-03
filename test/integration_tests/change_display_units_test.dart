import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Change Display Units', () {
    testWidgets('Initially, parameters should be displaying their common units',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then M:OUTTMP should show units of degF
      assertReadingPropertyUnits(forParameter: "M:OUTTMP@e,02", are: "degF");
    });

    testWidgets('Initially, Display Settings > Units is set to Common Units',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I navigate to the display settings page
      await navigateToDisplaySettings(tester);

      // Then Units is set to Common
      assertDisplaySettings(isVisible: true);
      assertDisplaySettingsUnits(isSetTo: "Common Units");
    });
  });
}
