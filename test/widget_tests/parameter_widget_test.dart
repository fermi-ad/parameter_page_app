import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/parameter_widget.dart';

void main() {
  group("ParameterWidget", () {
    assertAlarmDetails({required bool areVisible}) {
      expect(find.byKey(Key("parameter_alarms_nominal_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);
    }

    testWidgets('showAlarmDetails false, alarm details are not displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a ParameterEntry with showAlarmDetails = false
      const parameterWidgetApp = MaterialApp(
          home: Scaffold(body: ParameterWidget("M:OUTTMP", false, true)));
      await tester.pumpAndSettle();

      // Then the alarm details are not displayed
      assertAlarmDetails(areVisible: false);
    });
  });
}
