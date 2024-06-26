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

    testWidgets(
        'Knobbing enabled for device with a small step size, step size is shown with proper precision and formatting',
        (WidgetTester tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // ... and data for Z:NO_READ has been loaded
      await waitForDataToLoadFor(tester, "Z:NO_ALARMS");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap on the setting property
      await tapSetting(tester, forDRF: "Z:NO_ALARMS");

      // Then the knobbing controls are visisble
      assertKnobbingControls(areVisible: true, forDRF: "Z:NO_ALARMS");

      // ... and the step size is...
      assertKnobbing(stepSizeIs: "0.005", forDRF: "Z:NO_ALARMS");
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

    testWidgets(
        'Assign knobbing proportion to parameter, display proportion with parameter',
        (WidgetTester tester) async {
      // Given I am working on a new parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I add G:MULT1 with a proportion of 0.5
      await addANewEntry(tester, "G:MULT1*0.555");
      await exitEditMode(tester);

      // Then the proportion is displayed with the parameter
      assertParameterHasDetails("G:MULT1", proportion: "0.555");
    });

    testWidgets(
        'Tap setting control for parameter with proportion assigned, step size display includes the proportion (step size * proportion)',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... and a parameter with a knobbing proportion of 200
      await addANewEntry(tester, "G:MULT1*200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "G:MULT1");

      // Then the step size is scaled according to the proportion (step size * proportion)
      assertKnobbing(stepSizeIs: "1.0", forDRF: "G:MULT1");
    });

    testWidgets(
        'Knob parameter with proportion up multiple steps, proportion applied to each step',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... and a parameter with a knobbing proportion of 200
      await addANewEntry(tester, "G:MULT1*200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting value
      await tapSetting(tester, forDRF: "G:MULT1");

      // ... and knob up ten times
      for (int i = 0; i != 10; i++) {
        await knobUp(tester, steps: 1);

        // Then the text field value is adjusted on each step
        final expected = 50.0 + i + 1;
        assertSettingTextInputValue(
            forDRF: "G:MULT1", isSetTo: expected.toStringAsPrecision(4));
      }
    });

    testWidgets(
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // Given I have loaded Test Page 2
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I have added 4 parameters with proportions
      await enterEditMode(tester);
      await addANewEntry(tester, "G:MULT1*1");
      await addANewEntry(tester, "G:MULT2*-1");
      await addANewEntry(tester, "G:MULT3*2.5");
      await addANewEntry(tester, "G:MULT4*0.2");
      await exitEditMode(tester);

      // When I save the page, start a new page and then reload it
      await openMainMenu(tester);
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);
      await newPage(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then the knobbing proportions are still assigned
      assertKnobbingProportion(forDRF: "I:BEAM", isVisible: false);
      assertKnobbingProportion(forDRF: "R:BEAM", isVisible: false);
      assertKnobbingProportion(forDRF: "G:MULT1", isVisible: false);
      assertKnobbingProportion(forDRF: "G:MULT2", isVisible: true);
      assertParameterHasDetails("G:MULT2", proportion: "-1.0");
      assertKnobbingProportion(forDRF: "G:MULT3", isVisible: true);
      assertParameterHasDetails("G:MULT3", proportion: "2.5");
      assertKnobbingProportion(forDRF: "G:MULT4", isVisible: true);
      assertParameterHasDetails("G:MULT4", proportion: "0.2");
    }, semanticsEnabled: false);
  });
}
