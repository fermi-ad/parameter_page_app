// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameters in Unison (Mults)', () {
    testWidgets(
        'Assign knobbing proportion to parameter, displayed below setting value',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Knob parameter with proportion up multiple steps, proportion applied to each step',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Knob mult without proportions up multiple steps, parameters increment in unison',
        (WidgetTester tester) async {
      // Given a parameter page with a mult:3 followed by three parameters
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:3 Test Mult #1");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:MULT3");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // .. and the settings data has loaded
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");

      // When I tap the mult and knob up 4 times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobUp(tester, steps: 4);

      // Then the settings for each parameter belonging to the mult have been increment in unison
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "50.02");
      assertParameterHasDetails("G:MULT2", settingValue: "50.02");
      assertParameterHasDetails("G:MULT3", settingValue: "50.02");
    });

    testWidgets(
        'Knob mult without proportions down multiple steps, parameters decrement in unison',
        (WidgetTester tester) async {
      // Given a parameter page with a mult:3 followed by three parameters
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:3 Test Mult #1");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:MULT3");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // .. and the settings data has loaded
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");

      // When I tap the mult and knob up 4 times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobDown(tester, steps: 4);

      // Then the settings for each parameter belonging to the mult have been increment in unison
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "49.98");
      assertParameterHasDetails("G:MULT2", settingValue: "49.98");
      assertParameterHasDetails("G:MULT3", settingValue: "49.98");
    });

    testWidgets(
        'Knob mult with proportions up multiple steps, parameters increment in unison according to proportions',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult with proportions down multiple steps, parameters decrement in unison according according to proportions',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {});

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {});

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {});
  });
}
