import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/mock-dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/parameter_widget.dart';

void main() {
  group("ParameterWidget", () {
    assertAlarmDetails({required bool areVisible}) {
      expect(find.byKey(const Key("parameter_alarm_nominal_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);

      expect(find.byKey(const Key("parameter_alarm_tolerance_M:OUTTMP")),
          areVisible ? findsOneWidget : findsNothing);
    }

    testWidgets('showAlarmDetails false, alarm details are not displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a ParameterEntry with showAlarmDetails = false
      const scaffold = Scaffold(
          body: DataAcquisitionWidget(
              service: MockDpmService(useEmptyStream: true),
              child: ParameterWidget("M:OUTTMP", false, true)));
      const app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the alarm details are not displayed
      assertAlarmDetails(areVisible: false);
    });

    testWidgets('showAlarmDetails true, alarm details are displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a ParameterEntry with showAlarmDetails = true
      const app = MaterialApp(
          home: Scaffold(
              body: DataAcquisitionWidget(
                  service: MockDpmService(useEmptyStream: true),
                  child: ParameterWidget(
                    "M:OUTTMP",
                    false,
                    true,
                    displayAlarmDetails: true,
                  ))));
      await tester.pumpWidget(app);

      // Then the alarm details are displayed
      assertAlarmDetails(areVisible: true);
    });
  });
}
