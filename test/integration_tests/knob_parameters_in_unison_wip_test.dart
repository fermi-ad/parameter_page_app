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
      // This test might belong with Knob Parameter
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
