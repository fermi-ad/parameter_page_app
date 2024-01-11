import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Alarm Status', () {
    testWidgets('Parameter with no active alarm, display no alarm indicator',
        (tester) async {
      // Given nothing
      await startParameterPageApp(tester);

      // When the test page is loaded
      //   and a device with no active alarm is on the page
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");
      assertParametersAreOnPage(["M:OUTTMP@e,02"]);

      // Then nothing is display in the digitial status column
      assertAlarmStatus(tester, forDRF: "M:OUTTMP@e,02", isInAlarm: false);
    });

    testWidgets('Parameter is in alarm, display alarm indicator',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no active alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);

      // When an alarm is raised for G:AMANDA
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarm(tester, forDRF: "G:AMANDA");

      // Then the alarm indicator is displayed
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);
    });

    testWidgets('Parameter goes out of alarm, alarm indicator goes away',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarm(tester, forDRF: "G:AMANDA");
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA");
      await waitForAlarmToGoAway(tester, forDRF: "G:AMANDA");

      // Then the alarm indicator is hidden
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    });

    testWidgets(
        'Parameter goes out of tolerance with alarm by-passed, by-passed alarm indicator is shown',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in-tolerance with alarms by-passed is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);

      // When the device goes out-of-tolerance
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    });

    testWidgets(
        'Parameter is in tolerance with alarm by-passed, by-passed alarm indicator is shown',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is out-tolerance with alarms by-passed is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    });
  });
}
