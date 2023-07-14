import 'package:flutter/material.dart';
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
    testWidgets(
        'Tap outside when working on a setting, text field is removed and setting is cancelled',
        (tester) async {
      // Given I am attempting to set Z:BTE200_TEMP
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");

      // When I tap outside of the setting text field
      await tester
          .tap(find.byKey(const Key("parameter_description_Z:BTE200_TEMP")));
      await tester.pumpAndSettle();

      // Then the setting text field is hidden
      assertSettingTextInput(forDRF: "Z:BTE200_TEMP", isVisible: false);
    });

    // Test submit setting success & active undo update

    // Test submit setting failure

    // Test undo setting

    // Test passive undo update
  });
}
