import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Write to Parameter', () {
    testWidgets(
        'Tap Setting property, current setting appears in the undo column and text is replaced by an input field',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // When I tap the setting property
      await tapSetting(tester, forDRF: "M:OUTTMP@e,02");

      // Then the the setting text is replaced with a text input
      assertSettingTextInput(forDRF: "M:OUTTMP@e,02", isVisible: true);
    });

    // Test cancel setting

    // Test submit setting success

    // Test submit setting failure

    // Test undo setting

    // Test passive undo update
  });
}
