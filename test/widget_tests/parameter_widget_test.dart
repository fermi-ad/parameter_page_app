import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/mock-dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/parameter_widget.dart';

void main() {
  group("ParameterWidget", () {
    Future<void> waitForParameterToLoad(
      WidgetTester tester, {
      required String drf,
      Duration timeout = const Duration(seconds: 3),
    }) async {
      bool timerDone = false;
      final timer = Timer(timeout, () => timerDone = true);
      while (timerDone != true) {
        await tester.pump();

        final found = tester.any(find.byKey(Key("parameter_description_$drf")));
        if (found) {
          timerDone = true;
        }
      }
      timer.cancel();
    }

    assertAlarmDetailsAreVisible(bool areVisible) {
      expect(find.byKey(const Key("parameter_alarm_nominal_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);

      expect(find.byKey(const Key("parameter_alarm_tolerance_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);

      expect(find.byKey(const Key("parameter_alarm_min_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);

      expect(find.byKey(const Key("parameter_alarm_max_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);
    }

    assertAlarmDetails(
        {required String nominal,
        required String tolerance,
        required String min,
        required String max}) {
      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_alarm_nominal_M:OUTTMP")),
              matching: find.text(nominal)),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_alarm_tolerance_M:OUTTMP")),
              matching: find.text(tolerance)),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_alarm_min_M:OUTTMP")),
              matching: find.text(min)),
          findsOneWidget);

      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_alarm_max_M:OUTTMP")),
              matching: find.text(max)),
          findsOneWidget);
    }

    testWidgets('showAlarmDetails false, alarm details are not displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a ParameterEntry with showAlarmDetails = false
      Scaffold scaffold = Scaffold(
          body: DataAcquisitionWidget(
              service: MockDpmService(useEmptyStream: true),
              child: const ParameterWidget(
                  drf: "M:OUTTMP", editMode: false, wide: true)));
      MaterialApp app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the alarm details are not displayed
      assertAlarmDetailsAreVisible(false);
    });

    testWidgets(
        'showAlarmDetails true and alarmBlock is empty, alarm details are not displayed',
        (WidgetTester tester) async {
      // Given a parameter with no alarms block (Z:NO_ALARMS)
      // When I instantiate and display a ParameterWidget with showAlarmDetails = true
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: MockDpmService(useEmptyStream: true),
                  child: const ParameterWidget(
                    drf: "Z:NO_ALARMS",
                    editMode: false,
                    wide: true,
                    displayAlarmDetails: true,
                  ))));
      await tester.pumpWidget(app);
      await waitForParameterToLoad(tester, drf: "Z:NO_ALARMS");

      // Then the alarm details are NOT displayed
      assertAlarmDetailsAreVisible(false);
    });

    testWidgets('showAlarmDetails true, alarm details are displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a ParameterEntry with showAlarmDetails = true
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: MockDpmService(useEmptyStream: true),
                  child: const ParameterWidget(
                    drf: "M:OUTTMP",
                    editMode: false,
                    wide: true,
                    displayAlarmDetails: true,
                  ))));
      await tester.pumpWidget(app);
      await waitForParameterToLoad(tester, drf: "M:OUTTMP");

      // Then the alarm details are displayed
      assertAlarmDetailsAreVisible(true);
      assertAlarmDetails(
          nominal: "72.00", tolerance: "10.00", min: "62.00", max: "82.00");
    });

    testWidgets(
        'showAlarmDetails true and narrow mode, alarm details are displayed',
        (WidgetTester tester) async {
      // Given M:OUTTMP is a device with an alarm block
      // When I instantiate and display a ParameterEntry with showAlarmDetails = true and wide mode turned off
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: MockDpmService(useEmptyStream: true),
                  child: const ParameterWidget(
                    drf: "M:OUTTMP",
                    editMode: false,
                    wide: false,
                    displayAlarmDetails: true,
                  ))));
      await tester.pumpWidget(app);
      await waitForParameterToLoad(tester, drf: "M:OUTTMP");

      // Then the alarm details are displayed
      assertAlarmDetailsAreVisible(true);
    });
  });
}
