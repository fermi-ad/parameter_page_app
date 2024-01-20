import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Alarm Status', () {
    testWidgets(
        'Parameters without an alarm block, do not show analog alarm status',
        (WidgetTester tester) async {
      // Given nothing
      await startParameterPageApp(tester);

      // When the test page is loaded
      //   and a device with no alarm block is on the page
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:NO_ALARMS");

      // Then nothing is displayed in the analog alarm column
      assertAnalogAlarmIndicator(forDRF: "Z:NO_ALARMS", isVisible: false);
    });

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
    }, semanticsEnabled: false);

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
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm indicator is displayed
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);
    }, semanticsEnabled: false);

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
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA");
      await waitForAlarmToGoAway(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm indicator is hidden
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

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
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

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
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Alarming device by-passed by someone else, alarm indicator changes to by-passed',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // When someone else by-passes the alarm
      mockDPMService!.raiseAlarm(forDRF: "Z:BTE200_TEMP", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // Then the alarm inicator goes away
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: false);

      // ... and the by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "Z:BTE200_TEMP", isVisible: true);
    });

    testWidgets('By-pass alarming device, alarm indicator changes to by-passed',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I by-pass the alarm
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");

      // Then the alarm inicator goes away
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: false);

      // ... and the by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "Z:BTE200_TEMP", isVisible: true);
    });

    testWidgets(
        'By-pass non-alarming device, alarm indicator changes to by-passed',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I by-pass the alarm
      await toggleAnalogAlarm(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");

      // Then the by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);
    });

    testWidgets(
        'Enable alarm on out-of-tolerance parameter, alarm indicator is displayed',
        (tester) async {
      // Given the test page is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // ... and the alarm for Z:BTE200_TEMP has been by-passed
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: false);

      // When I re-enable the alarm
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");

      // Then the alarm indicator is shown
      assertAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);
    });
  });
}
