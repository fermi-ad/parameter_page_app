import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Change Display Units', () {
    testWidgets('Initially, display units should be Common Units',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then the display units should be set to Common Units
      assertDisplayUnits(isSetTo: "Common Units");

      // ... and M:OUTTMP should show units of degF
      assertReadingPropertyUnits(forParameter: "M:OUTTMP@e,02", are: "degF");
    });
  });
}
