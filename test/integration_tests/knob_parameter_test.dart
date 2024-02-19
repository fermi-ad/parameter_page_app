import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

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
      assertKnobbing(stepSizeIs: "1.0", forDRF: "G:AMANDA");
    });

    testWidgets('Knob up one step, setting is incremented by one step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for G:AMANDA has been loaded
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting property
      await tapSetting(tester, forDRF: "G:AMANDA");
      assertSettingTextInputValue(forDRF: "G:AMANDA", isSetTo: "50.00");

      // ... and then knob up by 1 step
      await knobUp(tester, steps: 1);

      // Then the value displayed in the setting control's text field is...
      assertSettingTextInputValue(forDRF: "G:AMANDA", isSetTo: "51.00");
    });

    testWidgets('Knob up n steps, setting is incremented by n * step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:BTE200_TEMP has been loaded
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "G:AMANDA");

      // ... and knob up ten times
      for (int i = 0; i != 10; i++) {
        await knobUp(tester, steps: 1);

        // Then the text field value is adjusted on each step
        final expected = 50.0 + i + 1;
        assertSettingTextInputValue(
            forDRF: "G:AMANDA", isSetTo: expected.toStringAsPrecision(4));
      }
    });

    testWidgets('Knob down n steps, setting is decremented by n * step size',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for G:AMANDA has been loaded
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "G:AMANDA");

      // ... and knob down ten times
      for (int i = 0; i != 10; i++) {
        await knobDown(tester, steps: 1);

        // Then the text field value is adjusted on each step
        final expected = 50.0 - i - 1;
        assertSettingTextInputValue(
            forDRF: "G:AMANDA", isSetTo: expected.toStringAsPrecision(4));
      }
    });
  });
}
