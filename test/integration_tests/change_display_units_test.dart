import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Change Display Units', () {
    testWidgets('Initially, parameters should be displaying their common units',
        (tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then M:OUTTMP should show units of degF
      assertParameterHasDetails("M:OUTTMP@e,02",
          settingValue: "50.00",
          settingUnits: "cUS",
          readingValue: "100.0",
          readingUnits: "cUR");
    });

    testWidgets('Initially, Display Settings > Units is set to Common Units',
        (tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I navigate to the display settings page
      await navigateToDisplaySettings(tester);

      // Then Units is set to Common
      assertDisplaySettings(isVisible: true);
      assertDisplaySettingsUnits(isSetTo: "Common Units");
    });

    testWidgets(
        'Change Display Settings > Units to Primary Units, M:OUTTMP units change to volts',
        (tester) async {
      // Given the test page is loaded and I am on the Display Settings page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await navigateToDisplaySettings(tester);

      // When I change Units to Primary Units and exit Display Settings
      await changeDisplaySettingsUnits(tester, to: "Primary Units");
      await navigateBackwards(tester);
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then the M:OUTTMP units change to Volts
      assertParameterHasDetails("M:OUTTMP@e,02",
          settingValue: "5.000",
          settingUnits: "pUS",
          readingValue: "10.00",
          readingUnits: "pUR");
    });

    testWidgets(
        'Change Display Settings > Units to Primary Units, change persists',
        (tester) async {
      // Given I have changed the DisplaySettings to Primary Units and returned to the parameter page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await navigateToDisplaySettings(tester);
      await changeDisplaySettingsUnits(tester, to: "Primary Units");
      await navigateBackwards(tester);

      // When I re-enter the Display Settings
      await navigateToDisplaySettings(tester);

      // Then Units is set to Primary Units
      assertDisplaySettingsUnits(isSetTo: "Primary Units");
    });

    testWidgets(
        'Change Display Settings > Units to Raw, no units are displayed',
        (tester) async {
      // Given the test page is loaded and I am on the Display Settings page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await navigateToDisplaySettings(tester);

      // When I change Units to Raw and exit Display Settings
      await changeDisplaySettingsUnits(tester, to: "Raw");
      await navigateBackwards(tester);
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then no units are display for M:OUTTMP
      assertParameterHasDetails("M:OUTTMP@e,02",
          settingValue: "8888", readingValue: "FFFF");
    });
  });
}
