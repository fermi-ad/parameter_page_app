import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Alarm Status', () {
    testWidgets('Settings are disabled, alarm toggle button is disabled',
        (WidgetTester tester) async {
      // Given settings are disabled
      await startParameterPageApp(tester);

      // When the test page is loaded
      //   and a device with no alarm block is on the page
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:NO_ALARMS");

      // Then the alarm toggle button is disabled
      assertAnalogAlarmToggle(tester,
          forDRF: "Z:BTE200_TEMP", isEnabled: false);
    });

    testWidgets('Parameters without an alarm block, do not show alarm status',
        (WidgetTester tester) async {
      // Given nothing
      await startParameterPageApp(tester);

      // When the test page is loaded
      //   and a device with no alarm block is on the page
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:NO_ALARMS");

      // Then nothing is displayed in the analog alarm column
      assertAnalogAlarmIndicator(forDRF: "Z:NO_ALARMS", isVisible: false);
      assertDigitalAlarmIndicator(forDRF: "Z:NO_ALARMS", isVisible: false);
    });

    testWidgets('Parameters not alarming, display the correct indicators',
        (tester) async {
      // Given nothing
      await startParameterPageApp(tester);

      // When the test page is loaded
      //   and a device with no active alarm is on the page
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");
      assertParametersAreOnPage(["M:OUTTMP@e,02", "G:AMANDA"]);

      // Then the parameters are not alarming in the analog or digital property
      assertAnalogAlarmStatus(tester,
          forDRF: "M:OUTTMP@e,02", isInAlarm: false);
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.notAlarming);
    }, semanticsEnabled: false);

    testWidgets('Parameter goes into alarm, display alarm indicator (analog)',
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
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);
    }, semanticsEnabled: false);

    testWidgets('Parameter goes into alarm, display alarm indicator (digital)',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no active alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);

      // When an alarm is raised for G:AMANDA
      mockDPMService!.raiseDigitalAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarmDigital(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm indicator is displayed
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.alarming);
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
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA");
      await waitForAlarmToGoAway(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm indicator is hidden
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Parameter goes out of alarm, alarm indicator goes away (digital)',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      mockDPMService!.raiseDigitalAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarmDigital(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.alarming);

      // When the device goes back in tolerance
      mockDPMService!.noAlarmDigital(forDRF: "G:AMANDA");
      await waitForDigitalAlarmToGoAway(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm indicator is hidden
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.notAlarming);
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
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);

      // When the device goes out-of-tolerance
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Parameter goes out of tolerance with alarm by-passed, by-passed alarm indicator is shown (digital)',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in-tolerance with alarms by-passed is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.notAlarming);

      // When the device goes out-of-tolerance
      mockDPMService!.raiseDigitalAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassedDigital(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.bypassed);
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
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);
    }, semanticsEnabled: false);

    testWidgets(
        'Parameter is in tolerance with alarm by-passed, by-passed alarm indicator is shown (digital)',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is out-tolerance with alarms by-passed is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      mockDPMService!.raiseDigitalAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDataToLoadFor(tester, "G:AMANDA");
      await waitForDeviceAlarmByPassedDigital(tester, forDRF: "G:AMANDA");
      assertParametersAreOnPage(["G:AMANDA"]);
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.bypassed);

      // When the device goes back in tolerance
      mockDPMService!.noAlarmDigital(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassedDigital(tester, forDRF: "G:AMANDA");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertDigitalAlarmStatus(tester,
          forDRF: "G:AMANDA", isInState: AlarmState.bypassed);
    }, semanticsEnabled: false);

    testWidgets(
        'Alarming device by-passed by someone else, alarm indicator changes to by-passed',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");
      assertAnalogAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // When someone else by-passes the alarm
      mockDPMService!.raiseAlarm(forDRF: "Z:BTE200_TEMP", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // Then the alarm inicator goes away
      assertAnalogAlarmStatus(tester,
          forDRF: "Z:BTE200_TEMP", isInAlarm: false);

      // ... and the by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "Z:BTE200_TEMP", isVisible: true);
    });

    testWidgets(
        'Alarming device by-passed by someone else, alarm indicator changes to by-passed (digital)',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarmDigital(tester, forDRF: "Z:BTE200_TEMP");
      assertAnalogAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // When someone else by-passes the alarm
      mockDPMService!
          .raiseDigitalAlarm(forDRF: "Z:BTE200_TEMP", isByPassed: true);
      await waitForDeviceAlarmByPassedDigital(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // Then the alarm inicator goes away
      assertDigitalAlarmStatus(tester,
          forDRF: "Z:BTE200_TEMP", isInState: AlarmState.bypassed);
    });

    testWidgets('By-pass alarming device, alarm indicator changes to by-passed',
        (tester) async {
      // Given a test page with an alarming device is loaded...
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");
      assertAnalogAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I by-pass the alarm
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");

      // Then the alarm inicator goes away
      assertAnalogAlarmStatus(tester,
          forDRF: "Z:BTE200_TEMP", isInAlarm: false);

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
      assertAnalogAlarmStatus(tester, forDRF: "G:AMANDA", isInAlarm: false);

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
      assertAnalogAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // ... and the alarm for Z:BTE200_TEMP has been by-passed
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceAlarmByPassed(tester, forDRF: "Z:BTE200_TEMP");
      assertAnalogAlarmStatus(tester,
          forDRF: "Z:BTE200_TEMP", isInAlarm: false);

      // When I re-enable the alarm
      await toggleAnalogAlarm(tester, forDRF: "Z:BTE200_TEMP");
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      await waitForDeviceToAlarm(tester, forDRF: "Z:BTE200_TEMP");

      // Then the alarm indicator is shown
      assertAnalogAlarmStatus(tester, forDRF: "Z:BTE200_TEMP", isInAlarm: true);
    });
  });
}
