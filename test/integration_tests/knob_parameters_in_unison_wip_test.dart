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
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    }, semanticsEnabled: false);

    testWidgets(
        'Knob mult with proportions up multiple steps, parameters increment in unison according to proportions',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... with a mult and three parameters assigned varying proportions
      await addANewEntry(tester, "mult:3");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2*200");
      await addANewEntry(tester, "G:MULT3*-200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");
      await waitForDataToLoadFor(tester, "G:MULT2");
      await waitForDataToLoadFor(tester, "G:MULT3");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the mult and knob up ten times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobUp(tester, steps: 10);

      // Then the values displayed are...
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "50.05");
      assertParameterHasDetails("G:MULT2", settingValue: "60.00");
      assertParameterHasDetails("G:MULT3", settingValue: "40.00");
    }, semanticsEnabled: false);

    testWidgets(
        'Knob mult with proportions down multiple steps, parameters decrement in unison according according to proportions',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... with a mult and three parameters assigned varying proportions
      await addANewEntry(tester, "mult:3");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2*200");
      await addANewEntry(tester, "G:MULT3*-200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");
      await waitForDataToLoadFor(tester, "G:MULT2");
      await waitForDataToLoadFor(tester, "G:MULT3");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the mult and knob up ten times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobDown(tester, steps: 10);

      // Then the values displayed are...
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "49.95");
      assertParameterHasDetails("G:MULT2", settingValue: "40.00");
      assertParameterHasDetails("G:MULT3", settingValue: "60.00");
    }, semanticsEnabled: false);

    testWidgets(
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);
  });
}
