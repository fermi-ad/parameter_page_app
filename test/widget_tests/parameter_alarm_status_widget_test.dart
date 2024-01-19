import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/parameter_alarm_status_widget.dart';

import '../integration_tests/helpers/actions.dart';

void main() {
  group("ParameterAlarmStatusWidget", () {
    testWidgets(
        'Open menu for alarming device, by-pass is enabled and enable alarm is not',
        (WidgetTester tester) async {
      // Given a ParameterAlarmStatusWidget has been rendered for an alarming device
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterAlarmStatusWidget(
                  drf: "G:AMANDA",
                  status: AnalogAlarmStatus(
                      refId: 0,
                      cycle: 0,
                      timestamp: DateTime.now(),
                      state: AnalogAlarmState.alarming))));
      await tester.pumpWidget(app);

      // When I open the menu
      await openParameterAlarmMenu(tester, forDRF: "G:AMANDA");

      // Then by-pass is enabled
      _assertByPassAlarm(tester, isEnabled: true);

      // ... and enable alarm is disabled
      _assertEnableAlarm(tester, isEnabled: false);
    });
  });
}

void _assertByPassAlarm(WidgetTester tester, {required bool isEnabled}) {
  final finder = find.ancestor(
      of: find.text("By-pass Alarm"),
      matching: find.byType(PopupMenuItem<String>));
  final menuItemWidget = tester.widget<PopupMenuItem>(finder);
  expect(menuItemWidget.enabled, isEnabled);
}

void _assertEnableAlarm(WidgetTester tester, {required bool isEnabled}) {
  final finder = find.ancestor(
      of: find.text("Enable Alarm"),
      matching: find.byType(PopupMenuItem<String>));
  final menuItemWidget = tester.widget<PopupMenuItem>(finder);
  expect(menuItemWidget.enabled, isEnabled);
}
