import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Change Parameter Alarm Min/Max/Tolerance', () {
    testWidgets('Display Settings > Show Alarm Details, initially is OFF',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I navigate to the display settings page
      await navigateToDisplaySettings(tester);

      // Then Show Parameter Alarm Details is set to off
      assertDisplaySettings(isVisible: true);
      assertDisplaySettingsShowAlarmDetails(isOn: false);
    });

    testWidgets(
        'Turn on Display Settings > Show Alarm Details, change persists',
        (tester) async {
      // Given I have turned on Show Parameter Alarm Details
      app.main();
      await tester.pumpAndSettle();
      await navigateToDisplaySettings(tester);
      await toggleShowAlarmDetails(tester);

      // When I navigate to the parameter page and then back to display settings
      await navigateBackwards(tester);
      await navigateToDisplaySettings(tester);

      // Then Show Parameter Alarm Details is set to on
      assertDisplaySettings(isVisible: true);
      assertDisplaySettingsShowAlarmDetails(isOn: true);
    });

    testWidgets(
        'Turn on Display Settings > Show Alarm Details, alarm details are shown',
        (tester) async {
      // Given the test parameter page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I turn on Show Alarm Details and return to the parameter page
      await navigateToDisplaySettings(tester);
      await toggleShowAlarmDetails(tester);
      await navigateBackwards(tester);

      // Then the nominal value, tolerance and min/max alarm details are displayed for M:OUTTMP
      assertAlarmValues(
          forDRF: "M:OUTTMP@e,02",
          nominal: "72.00",
          tolerance: "10.00",
          min: "62.00",
          max: "82.00");

      // ... but they are not shown for Z:NO_ALARMS
      assertAlarmDetails(forDRF: "Z:NO_ALARMS", areVisible: false);
    });
  });
}
