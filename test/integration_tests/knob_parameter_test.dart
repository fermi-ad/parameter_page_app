import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameter', () {
    testWidgets(
        'Knobbing disabled for device, knobbing controls are not displayed',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:NO_READ has been loaded
      await waitForDataToLoadFor(tester, "Z:NO_READ");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap on the setting property
      await tapSetting(tester, forDRF: "Z:NO_READ");

      // Then there are no knobbing controls
      assertKnobbingControls(areVisible: false, forDRF: "Z:NO_READ");
    });

    testWidgets(
        'Knobbing enabled for device, knobbing controls are visible and show correct step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for G:AMANDA has been loaded
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap on the setting property
      await tapSetting(tester, forDRF: "G:AMANDA");

      // Then the knobbing controls are visisble
      assertKnobbingControls(areVisible: true, forDRF: "G:AMANDA");

      // ... and the step size is...
      assertKnobbing(stepSizeIs: "0.005", forDRF: "G:AMANDA");
    });

    testWidgets('Knob up one step, setting is incremented by one step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:BTE200_TEMP has been loaded
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting property
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "50.00");

      // ... and then knob up by 1 step
      await knobUp(tester, steps: 1);

      // Then the value displayed in the setting control's text field is...
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "51.00");

      // ... and the last value sent for Z:BTE200_TEMP is...
      expect(mockDPMService!.pendingSettingValue!.value, equals(51.0));
    });

    testWidgets('Knob up n steps, setting is incremented by n * step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:BTE200_TEMP has been loaded
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");

      // ... and knob up ten times
      for (int i = 0; i != 10; i++) {
        await knobUp(tester, steps: 1);

        // Then the text field value is adjusted on each step
        final expected = 50.0 + i + 1;
        assertSettingTextInputValue(
            forDRF: "Z:BTE200_TEMP", isSetTo: expected.toStringAsPrecision(4));

        // ... and a new setting is sent
        expect(mockDPMService!.pendingSettingValue!.value, equals(expected),
            reason: "The new value ($expected) was not submitted to DPM");
      }
    });

    testWidgets('Knob down n steps, setting is decremented by n * step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:BTE200_TEMP has been loaded
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");

      // ... and knob down ten times
      for (int i = 0; i != 10; i++) {
        await knobDown(tester, steps: 1);

        // Then the text field value is adjusted on each step
        final expected = 50.0 - i - 1;
        assertSettingTextInputValue(
            forDRF: "Z:BTE200_TEMP", isSetTo: expected.toStringAsPrecision(4));

        // ... and a new setting is sent
        expect(mockDPMService!.pendingSettingValue!.value, equals(expected),
            reason: "The new value ($expected) was not submitted to DPM");
      }
    });
  });
}
