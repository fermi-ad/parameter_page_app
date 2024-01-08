import 'package:flutter/material.dart';
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
      assertParametersAreOnPage(["M:OUTTMP@e,02"]);

      // Then nothing is display in the digitial status column
      assertAlarmStatus(forDRF: "M:OUTTMP@e,02", isInAlarm: false);
    });

    testWidgets('Parameter is in alarm, display alarm indicator',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no active alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["G:AMANDA"]);

      // When an alarm is raised for G:AMANDA
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarm(tester, forDRF: "G:AMANDA");

      // Then the alarm indicator is displayed
      assertAlarmStatus(forDRF: "G:AMANDA", isInAlarm: true);
    });

    testWidgets('Parameter goes out of alarm, alarm indicator goes away',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["G:AMANDA"]);
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA");
      await waitForDeviceToAlarm(tester, forDRF: "G:AMANDA");
      assertAlarmStatus(forDRF: "G:AMANDA", isInAlarm: true);

      // When the device goes back in tolerance
      mockDPMService!.noAlarm(forDRF: "G:AMANDA");
      await waitForAlarmToGoAway(tester, forDRF: "G:AMANDA");

      // Then the alarm indicator is hidden
      assertAlarmStatus(forDRF: "G:AMANDA", isInAlarm: false);
    });

    testWidgets(
        'Parameter goes out of tolerance with alarm by-passed, by-passed alarm indicator is shown',
        (tester) async {
      // Given the test page is loaded
      //   and a device that is in-tolerance with alarms by-passed is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["G:AMANDA"]);
      assertAlarmStatus(forDRF: "G:AMANDA", isInAlarm: false);

      // When the device goes out-of-tolerance
      mockDPMService!.raiseAlarm(forDRF: "G:AMANDA", isByPassed: true);
      await waitForDeviceAlarmByPassed(tester, forDRF: "G:AMANDA");

      // Then the alarm by-passed indicator is shown
      assertByPassedAlarmStatus(forDRF: "G:AMANDA", isVisible: true);

      // ... but the device is not in alarm
      assertAlarmStatus(forDRF: "G:AMANDA", isInAlarm: false);
    });
  });
}

Future<void> waitForAlarmToGoAway(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications));
  await pumpUntilGone(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceToAlarm(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceAlarmByPassed(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_off));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

void assertAlarmStatus({required String forDRF, required bool isInAlarm}) {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications));
  expect(alarmIndicatorFinder, isInAlarm ? findsOneWidget : findsNothing);
}

void assertByPassedAlarmStatus(
    {required String forDRF, required bool isVisible}) {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_off));
  expect(alarmIndicatorFinder, isVisible ? findsOneWidget : findsNothing);
}
