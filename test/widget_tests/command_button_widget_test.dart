import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/mock-dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/command_button_widget.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

void main() {
  MockDpmService testDPM = MockDpmService();

  MaterialApp initialize(Widget child) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      SizedBox(
          width: 300.0,
          height: 34.0,
          child: DataAcquisitionWidget(service: testDPM, child: child))
    ])));
  }

  void tap() {}

  void assertButton({required bool isEnabled}) {}

  void assertPendingIndicator({required bool isVisible}) {}

  group("CommandButtWidget", () {
    testWidgets('Tap, displays pending icon', (WidgetTester tester) async {
      // Given a command button
      MaterialApp app = initialize(const CommandButtonWidget(
          drf: "G:AMANDA", value: 0, longName: "Reset"));
      await tester.pumpWidget(app);

      // When I tap the button
      tap();

      // Then the button is disabled and the pending icon is shown
      assertButton(isEnabled: false);
      assertPendingIndicator(isVisible: true);
    });
  });
}
