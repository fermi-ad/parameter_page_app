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

  Future<void> tap(WidgetTester tester,
      {required String buttonWithText}) async {
    await tester.tap(find.text(buttonWithText));
    await tester.pumpAndSettle();
  }

  void assertButton(WidgetTester tester, {required bool isEnabled}) {
    final finder = find.byType(ElevatedButton);

    // Verify that the ElevatedButton is disabled
    expect(tester.widget<ElevatedButton>(finder).enabled, isEnabled);
  }

  void assertPendingIndicator({required bool isVisible}) {
    expect(
        find.byIcon(Icons.pending), isVisible ? findsOneWidget : findsNothing);
  }

  void assertErrorIndicator(WidgetTester tester,
      {required bool isVisible, int? facilityCode, int? errorCode}) {
    final finder = find.byType(ElevatedButton);
    expect(tester.widget<Material>(finder).color,
        isVisible ? Colors.red : Colors.blue);

    if (isVisible && facilityCode != null && errorCode != null) {
      expect(
          find.descendant(
              of: finder, matching: find.text("$facilityCode $errorCode")),
          findsOneWidget);
    }
  }

  group("CommandButtWidget", () {
    testWidgets('Tap, displays pending icon', (WidgetTester tester) async {
      // Given a command button
      MaterialApp app = initialize(const CommandButtonWidget(
          drf: "G:AMANDA", value: 0, longName: "Reset"));
      await tester.pumpWidget(app);

      // When I tap the button
      await tap(tester, buttonWithText: "Reset");

      // Then the button is disabled and the pending icon is shown
      assertButton(tester, isEnabled: false);
      assertPendingIndicator(isVisible: true);
    });

    testWidgets('On command success, transitions back to enabled state',
        (WidgetTester tester) async {
      // Given a command button that is in the pending state
      MaterialApp app = initialize(const CommandButtonWidget(
          drf: "G:AMANDA", value: 0, longName: "Reset"));
      await tester.pumpWidget(app);
      await tap(tester, buttonWithText: "Reset");
      assertButton(tester, isEnabled: false);
      assertPendingIndicator(isVisible: true);

      // When the command returns a successful status
      testDPM.succeedAllPendingSettings();
      await tester.pumpAndSettle();

      // The the button is enabled and the pending icon is gone
      assertButton(tester, isEnabled: true);
      assertPendingIndicator(isVisible: false);
    });

    testWidgets(
        'On command failure, display a red background and error code for three seconds',
        (WidgetTester tester) async {
      // Given a command button that is in the pending state
      MaterialApp app = initialize(const CommandButtonWidget(
          drf: "G:AMANDA", value: 0, longName: "Reset"));
      await tester.pumpWidget(app);
      await tap(tester, buttonWithText: "Reset");
      assertButton(tester, isEnabled: false);
      assertPendingIndicator(isVisible: true);

      // When the command returns an error status
      testDPM.failAllPendingSettings(facilityCode: 57, errorCode: -10);
      await tester.pumpAndSettle();

      // Then the button indicates an error for three seconds
      assertErrorIndicator(tester,
          isVisible: true, facilityCode: 57, errorCode: -10);
      tester.pumpAndSettle(const Duration(seconds: 3, milliseconds: 10));
      assertErrorIndicator(tester, isVisible: false);
    });
  });
}
