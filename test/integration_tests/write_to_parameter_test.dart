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
    testWidgets(
        'Submit a new setting successfully, see the update reflect in the display and the old value provided in the undo column',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // When I submit a new setting...
      await tapSetting(tester, forDRF: "G:AMANDA");
      await submitSetting(tester, forDRF: "G:AMANDA", newValue: "75.0");
      await waitForSettingDataToLoad(tester, forDRF: "G:AMANDA");
      await tester.pumpAndSettle();

      // Then the text field goes away
      assertSettingTextInput(forDRF: "G:AMANDA", isVisible: false);

      // ... and the display shows the new value
      assertParameterHasDetails("G:AMANDA", settingValue: "75.00");

      // ... and the undo display shows the old value
      assertUndo(forDRF: "G:AMANDA", isVisible: true, isValue: "50.00");
    });

    // Test submit setting failure
    testWidgets('Failed setting, displays error message for three seconds',
        (tester) async {
      // Given the test page is loaded with a device whose setting is broken
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // When I attempt to set a device that will always fail
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");
      await submitSetting(tester, forDRF: "Z:BTE200_TEMP", newValue: "75.0");
      await waitForSettingErrorToBeReturned(tester, forDRF: "Z:BTE200_TEMP");
      await tester.pumpAndSettle();

      // Then the error code is displayed
      assertSettingError(
          forDRF: "Z:BTE200_TEMP",
          isVisible: true,
          facilityCode: 57,
          errorCode: -10);
    });

    // Test passive undo update
    testWidgets('Setting changes, undo displays the original setting value',
        (tester) async {
      // Given the test page is loaded with a device whose setting increments once a second
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "Z:INC_SETTING");
      assertUndo(forDRF: "Z:INC_SETTING", isVisible: false);

      // When I wait one second for the setting to change
      await waitForUndoToDisplay(tester, forDRF: "Z:INC_SETTING");

      // Then the undo is dispayed showing the original setting
      assertUndo(forDRF: "Z:INC_SETTING", isVisible: true);
    });

    // Test undo setting
    testWidgets('Click Undo display, original value is submitted and set',
        (tester) async {
      // Given I have set a new value for the G:AMANDA device
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "G:AMANDA");
      await tapSetting(tester, forDRF: "G:AMANDA");
      await submitSetting(tester, forDRF: "G:AMANDA", newValue: "51.0");
      await waitForSettingDataToLoad(tester, forDRF: "G:AMANDA");
      await waitForUndoToDisplay(tester, forDRF: "G:AMANDA");

      // When I tap the undo value
      await undoSetting(tester, forDRF: "G:AMANDA");

      // Then the original value is restored successfully
      await waitForSettingDataToLoad(tester, forDRF: "G:AMANDA");
      assertParameterHasDetails("G:AMANDA", settingValue: "50.00");
    });
  });
}
