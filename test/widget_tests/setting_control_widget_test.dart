import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/mock-dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

void main() {
  MaterialApp initialize(Widget child) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      SizedBox(
          key: const Key("parameter_setting_Z:BTE200_TEMP"),
          width: 200.0,
          height: 34.0,
          child: child),
      const SizedBox(
          key: Key("test_empty_box"),
          height: 100.0,
          width: 200.0,
          child: Text("Abort"))
    ])));
  }

  void assertSettingDisplay({required bool isVisible, String? value}) {
    expect(find.byKey(const Key("parameter_settingdisplay_Z:BTE200_TEMP")),
        isVisible ? findsOneWidget : findsNothing);

    if (isVisible && value != null) {
      expect(
          find.descendant(
              of: find
                  .byKey(const Key("parameter_settingdisplay_Z:BTE200_TEMP")),
              matching: find.text(value)),
          findsOneWidget);
    }
  }

  void assertSettingInput({required bool isVisible, String? value}) {
    expect(
        find.byType(TextFormField), isVisible ? findsOneWidget : findsNothing);
  }

  void assertSettingPendingIndicator({required bool isVisible}) {
    expect(
        find.descendant(
            of: find.byKey(const Key("parameter_setting_Z:BTE200_TEMP")),
            matching: find.byIcon(Icons.pending)),
        isVisible ? findsOneWidget : findsNothing);
  }

  group("SettingControlWidget", () {
    testWidgets('Provide no initial value, displays 0.0',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP
      MaterialApp app =
          initialize(const SettingControlWidget(drf: "Z:BTE200_TEMP"));

      // When I display the setting
      await tester.pumpWidget(app);

      // Then 0.0 is displayed
      assertSettingDisplay(isVisible: true, value: "0.0");
    });

    testWidgets('Provide an initial value, displays that value',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      MaterialApp app = initialize(
          const SettingControlWidget(drf: "Z:BTE200_TEMP", value: "72.0"));

      // When I display the setting
      await tester.pumpWidget(app);

      // Then 72.0 is displayed
      assertSettingDisplay(isVisible: true, value: "72.0");
    });

    testWidgets('Tap, change to text input', (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      MaterialApp app = initialize(
          const SettingControlWidget(drf: "Z:BTE200_TEMP", value: "72.0"));

      // When I display the setting and tap on it
      await tester.pumpWidget(app);
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();

      // Then 72.0 is displayed inside of a text input field
      assertSettingInput(isVisible: true, value: "72.0");
    });

    testWidgets('Press escape while editing, return to text display',
        (WidgetTester tester) async {
      // Given I am editing a setting inside of a SettingControlWidget...
      MaterialApp app = initialize(
          const SettingControlWidget(drf: "Z:BTE200_TEMP", value: "72.0"));
      await tester.pumpWidget(app);
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      assertSettingInput(isVisible: true, value: "72.0");

      // When give the input field focus but then abort by pressing the escape key
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Then the text field changes back to a text display
      assertSettingDisplay(isVisible: true, value: "72.0");
    });

    testWidgets('Tap outside while editing, return to text display',
        (WidgetTester tester) async {
      // Given I am editing a setting inside of a SettingControlWidget...
      MaterialApp app = initialize(
          const SettingControlWidget(drf: "Z:BTE200_TEMP", value: "72.0"));
      await tester.pumpWidget(app);
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      assertSettingInput(isVisible: true, value: "72.0");

      // When give the input field focus but then abort by tapping outside of the control
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("test_empty_box")));
      await tester.pumpAndSettle();

      // Then the text field changes back to a text display
      assertSettingDisplay(isVisible: true, value: "72.0");
    });

    testWidgets(
        'Enter new value and submit, onSubmit is called and widget shows the setting is pending',
        (WidgetTester tester) async {
      //Given a SettingControlWidget with an onSubmitted handler that updates newValue
      String newValue = "";
      MaterialApp app = initialize(SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          value: "72.0",
          onSubmitted: (String submitted) {
            newValue = submitted;
          }));
      await tester.pumpWidget(app);

      // When I tap on the setting and enter a new value
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "75.0");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Then the onSubmit handler is called and passed "75.0" as the new value
      expect(newValue, equals("75.0"));

      // ... the display is showing the new value
      assertSettingDisplay(isVisible: true, value: "75.0");

      // ... and the pending indicator is shown
      assertSettingPendingIndicator(isVisible: true);
    });

    testWidgets(
        'On setting success, transition back to displaying the current setting',
        (WidgetTester tester) async {
      // Given I have submitted a new setting for Z:BTE200_TEMP
      MockDpmService testDPM = MockDpmService();
      MaterialApp app = initialize(DataAcquisitionWidget(
          service: testDPM,
          child: const SettingControlWidget(
            drf: "Z:BTE200_TEMP",
            value: "72.0",
          )));
      await tester.pumpWidget(app);
      await tester.tap(find.text("72.0"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "75.0");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // When the setting is successful
      testDPM.succeedAllPendingSettings();
      await tester.pumpAndSettle();

      // Then the pending indicator goes away
      assertSettingPendingIndicator(isVisible: false);
    });

    testWidgets('Provide units, display units', (WidgetTester tester) async {
      //Given a SettingControlWidget constructed with units provided
      MaterialApp app = initialize(const SettingControlWidget(
        drf: "Z:BTE200_TEMP",
        value: "72.0",
        units: "degF",
      ));

      // When I display
      await tester.pumpWidget(app);

      // Then the units are displayed
      expect(find.text("degF"), findsOneWidget);
    });
  });
}
