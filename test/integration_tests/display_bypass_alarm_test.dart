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
  });
}

Future<void> waitForDeviceToAlarm(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

void assertAlarmStatus({required String forDRF, required bool isInAlarm}) {
  final parameterFinder = find.byKey(Key("parameter_row_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications));
  expect(alarmIndicatorFinder, isInAlarm ? findsOneWidget : findsNothing);
}
