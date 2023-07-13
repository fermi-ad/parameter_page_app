import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Write to Parameter', () {
    testWidgets('Tap Setting property, text is replaced by an input field',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // When I tap the setting property for M:OUTTMP
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");

      // Then the the setting text is replaced with a text input
      assertSettingTextInput(forDRF: "Z:BTE200_TEMP", isVisible: true);
    });

    // Test cancel setting

    // Test submit setting success & active undo update

    // Test submit setting failure

    // Test undo setting

    // Test passive undo update
  });
}
