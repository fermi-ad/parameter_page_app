import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

import '../integration_tests/helpers/actions.dart';
import '../integration_tests/helpers/assertions.dart';

void main() {
  MockDpmService testDPM = MockDpmService();

  MaterialApp initialize(Widget child) {
    return MaterialApp(
        home: Scaffold(
            body: Column(children: [
      SizedBox(
          key: const Key("parameter_setting_Z:BTE200_TEMP"),
          width: 330.0,
          height: 34.0,
          child: DataAcquisitionWidget(service: testDPM, child: child)),
      const SizedBox(
          key: Key("test_empty_box"),
          height: 100.0,
          width: 330.0,
          child: Text("Abort"))
    ])));
  }

  Future<void> sendSettingTestData(WidgetTester tester,
      {required double settingValue}) async {
    testDPM.updateSetting(
        forDRF: "Z:BTE200_TEMP",
        value: settingValue,
        primaryValue: settingValue / 10.0,
        rawValue: "7777");
    await tester.pumpAndSettle();
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

  void assertSettingLoading({required bool isVisible}) {
    expect(find.byKey(const Key("parameter_settingloading_Z:BTE200_TEMP")),
        isVisible ? findsOneWidget : findsNothing);
  }

  void assertSettingInput({required bool isVisible, String? value}) {
    expect(
        find.byType(TextFormField), isVisible ? findsOneWidget : findsNothing);
  }

  void assertSettingPendingIndicator({required bool isVisible, String? value}) {
    expect(
        find.descendant(
            of: find.byKey(const Key("parameter_setting_Z:BTE200_TEMP")),
            matching: find.byIcon(Icons.pending)),
        isVisible ? findsOneWidget : findsNothing);

    if (isVisible && value != null) {
      expect(
          find.descendant(
              of: find.byKey(
                  const Key("parameter_settingpendingdisplay_Z:BTE200_TEMP")),
              matching: find.text(value)),
          findsOneWidget);
    }
  }

  void assertErrorCodeDisplay(
      {required bool isVisible, int? facilityCode, int? errorCode}) {
    expect(find.byKey(const Key("parameter_settingerror_Z:BTE200_TEMP")),
        isVisible ? findsOneWidget : findsNothing);

    if (isVisible && facilityCode != null && errorCode != null) {
      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_setting_Z:BTE200_TEMP")),
              matching: find.text("$facilityCode $errorCode")),
          findsOneWidget);
    }
  }

  void assertUndoSettingDisplay({required bool isVisible, String? value}) {
    expect(find.byKey(const Key("parameter_settingundo_Z:BTE200_TEMP")),
        isVisible ? findsOneWidget : findsNothing);

    if (isVisible && value != null) {
      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_settingundo_Z:BTE200_TEMP")),
              matching: find.text(value)),
          findsOneWidget);
    }
  }

  group("SettingControlWidget", () {
    testWidgets('No data from stream yet, displays Loading...',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));

      // When I display the setting
      await tester.pumpWidget(app);

      // Then 0.0 is displayed
      assertSettingDisplay(isVisible: false);
      assertSettingLoading(isVisible: true);
    });

    testWidgets('Provide an initial value, displays that value',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);

      // When setting data arrives
      await sendSettingTestData(tester, settingValue: 72.0);

      // Then 72.0 is displayed
      assertSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets('Tap, change to text input', (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);

      // When I display the setting and tap on it
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then 72.0 is displayed inside of a text input field
      assertSettingInput(isVisible: true, value: "72.00");
    });

    testWidgets('Press escape while editing, return to text display',
        (WidgetTester tester) async {
      // Given I am editing a setting inside of a SettingControlWidget...
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      assertSettingInput(isVisible: true, value: "72.00");

      // When give the input field focus but then abort by pressing the escape key
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Then the text field changes back to a text display
      await sendSettingTestData(tester, settingValue: 72.0);
      assertSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets('Tap cancel while editing, return to text display',
        (WidgetTester tester) async {
      // Given I am editing a setting inside of a SettingControlWidget...
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      assertSettingInput(isVisible: true, value: "72.00");

      // When give the input field focus but then abort by tapping outside of the control
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      // Then after recieving an update the text field changes back to a text display
      await sendSettingTestData(tester, settingValue: 72.0);
      assertSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets(
        'Enter new value and submit, onSubmit is called and widget shows the setting is pending',
        (WidgetTester tester) async {
      //Given a SettingControlWidget with an onSubmitted handler that updates newValue
      String newValue = "";
      MaterialApp app = initialize(SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          onSubmitted: (String submitted) {
            newValue = submitted;
          }));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);

      // When I tap on the setting and enter a new value
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "75.0");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Then the onSubmit handler is called and passed "75.0" as the new value
      expect(newValue, equals("75.0"));

      // ... and the display is showing the new value as pending
      assertSettingPendingIndicator(isVisible: true, value: "75.0");
    });

    testWidgets(
        'Enter new value and submit with submit button, onSubmit is called',
        (WidgetTester tester) async {
      //Given a SettingControlWidget with an onSubmitted handler that updates newValue
      String newValue = "";
      MaterialApp app = initialize(SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          onSubmitted: (String submitted) {
            newValue = submitted;
          }));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);

      // When I tap on the setting, enter a new value and tap the submit button
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "75.0");
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      // Then the onSubmit handler is called and passed "75.0" as the new value
      expect(newValue, equals("75.0"));
    });

    testWidgets(
        'On setting success, transition back to displaying the current setting',
        (WidgetTester tester) async {
      // Given I have submitted a new setting for Z:BTE200_TEMP
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
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
        displayUnits: DisplayUnits.commonUnits,
        units: "degF",
      ));

      // When I display
      await tester.pumpWidget(app);
      testDPM.updateSetting(
          forDRF: "Z:BTE200_TEMP",
          value: 72.0,
          primaryValue: 7.2,
          rawValue: "7777");
      await tester.pumpAndSettle();

      // Then the units are displayed
      expect(find.text("degF"), findsOneWidget);
    });

    testWidgets(
        'On setting failure, display error for three seconds then transition back to display',
        (WidgetTester tester) async {
      // Given I have submitted a new setting for Z:BTE200_TEMP
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "75.0");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // When the setting fails and returns a 57 -30 error
      testDPM.failAllPendingSettings(facilityCode: 57, errorCode: -30);
      await tester.pumpAndSettle();

      // Then the pending indicator goes away
      assertSettingPendingIndicator(isVisible: false);

      // ... and an error code is displayed
      assertErrorCodeDisplay(isVisible: true, facilityCode: 57, errorCode: -30);

      // ... and after three seconds the error code goes away
      await tester.pumpWidget(app, const Duration(seconds: 3, milliseconds: 1));
      assertErrorCodeDisplay(isVisible: false);

      // ... and the original setting is displayed again
      await sendSettingTestData(tester, settingValue: 72.0);
      assertSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets(
        'After 6 seconds with no changes in edit state, return to display state',
        (WidgetTester tester) async {
      // Given I am editing a setting property
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // When I wait 3 seconds without making a change
      await tester.pumpWidget(app, const Duration(seconds: 6, milliseconds: 1));

      // Then the setting is cancelled and the setting display returns
      await sendSettingTestData(tester, settingValue: 72.0);
      assertSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets('On new setting, undo display shows the original setting',
        (WidgetTester tester) async {
      // Given the original setting for Z:BTE200_TEMP is 72.0
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);

      // When a new setting arrives
      await sendSettingTestData(tester, settingValue: 75.0);

      // Then the Undo display shows the original setting value
      assertUndoSettingDisplay(isVisible: true, value: "72.00");
    });

    testWidgets(
        'Set displayUnits to Primary, see Settings data in Primary units',
        (WidgetTester tester) async {
      // Given I am displaying the setting for Z:BTE200_TEMP with displayUnits set to primary units
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.primaryUnits));
      await tester.pumpWidget(app);

      // When I display new data
      await sendSettingTestData(tester, settingValue: 50.0);
      await tester.pumpAndSettle();

      // Then the primary value is displayed
      assertSettingDisplay(isVisible: true, value: "5.000");
    });

    testWidgets('Set displayUnits to raw, see Settings data in raw units',
        (WidgetTester tester) async {
      // Given I am displaying the setting for Z:BTE200_TEMP with displayUnits set to raw units
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.raw));
      await tester.pumpWidget(app);

      // When I display new data
      await sendSettingTestData(tester, settingValue: 50.0);
      await tester.pumpAndSettle();

      // Then the primary value is displayed
      assertSettingDisplay(isVisible: true, value: "7777");
    });

    testWidgets('Tap undo, submits setting', (WidgetTester tester) async {
      // Given I have submitted a new setting for Z:BTE200_TEMP
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP", displayUnits: DisplayUnits.commonUnits));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await sendSettingTestData(tester, settingValue: 75.0);
      await tester.pumpAndSettle();

      // When I tap the undo value
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the undo value is submitted as a new setting
      assertSettingPendingIndicator(isVisible: true);
      expect(testDPM.pendingSettingValue!.value, equals(72.0));
    });

    testWidgets('settingsAllowed: false, inhibits editing',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to false
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: false));
      await tester.pumpWidget(app);

      // When I display the setting and tap on it
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the text input field is not shown
      assertSettingInput(isVisible: false);
    });

    testWidgets('Tap undo with settings disabled, does not submit setting',
        (WidgetTester tester) async {
      // Given settings are disabled
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: false));
      await tester.pumpWidget(app);

      // ... and the setting value has changed
      await sendSettingTestData(tester, settingValue: 72.0);
      await sendSettingTestData(tester, settingValue: 75.0);
      await tester.pumpAndSettle();

      // When I tap the undo value
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the undo value is not submitted and stays the same
      assertSettingPendingIndicator(isVisible: false);
    });

    testWidgets('Knobbing disabled, step size is not shown',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      // ... and knobbing is disabled
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: false));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();

      // When tapped
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the knobbing controls are NOT visible
      assertKnobbingControls(areVisible: false, forDRF: "Z:BTE200_TEMP");
    });

    testWidgets('Knobbing enabled, step size shown only when tapped',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();
      assertKnobbingControls(areVisible: false, forDRF: "Z:BTE200_TEMP");

      // When tapped
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the knobbing controls are visible
      assertKnobbingControls(areVisible: true, forDRF: "Z:BTE200_TEMP");

      // ... and the step size is 0.005
      assertKnobbing(stepSizeIs: "1.0", forDRF: "Z:BTE200_TEMP");
    });

    testWidgets('Supply step size, step size is properly formatted',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true,
          knobbingStepSize: 0.005));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();
      assertKnobbingControls(areVisible: false, forDRF: "Z:BTE200_TEMP");

      // When tapped
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();

      // Then the knobbing controls are visible
      assertKnobbingControls(areVisible: true, forDRF: "Z:BTE200_TEMP");

      // ... and the step size is 0.005
      assertKnobbing(stepSizeIs: "0.005", forDRF: "Z:BTE200_TEMP");
    });

    testWidgets('Press F5 in edit mode, input value is knobbed up by 1 step',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      // ... and the step size is 1.0
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true,
          knobbingStepSize: 1.0));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();

      // When I enter edit mode and knob up once
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await knobUp(tester, steps: 1);

      // Then the value in the input field is incremented by 1 step
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "73.00");
    });

    testWidgets('Press F4 in edit mode, input value is knobbed down by 1 step',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      // ... and the step size is 1.0
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true,
          knobbingStepSize: 1.0));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();

      // When I enter edit mode and knob down once
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await knobDown(tester, steps: 1);

      // Then the value in the input field is decremented by 1 step
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "71.00");
    });

    testWidgets('Knob down 10 times, input value is knobbed down by 10 steps',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      // ... and the step size is 1.0
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true,
          knobbingStepSize: 1.0));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();

      // When I enter edit mode and knob down ten times
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await knobDown(tester, steps: 10);

      // Then the value in the input field is decremented by 10 steps
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "62.00");
    });

    testWidgets('Knob up 10 times, input value is knobbed up by 10 steps',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP with an initial value of "72.0"
      // ... and settingsAllowed is set to true
      // ... and the step size is 1.0
      MaterialApp app = initialize(const SettingControlWidget(
          drf: "Z:BTE200_TEMP",
          displayUnits: DisplayUnits.commonUnits,
          settingsAllowed: true,
          knobbingEnabled: true,
          knobbingStepSize: 1.0));
      await tester.pumpWidget(app);
      await sendSettingTestData(tester, settingValue: 72.0);
      await tester.pumpAndSettle();

      // When I enter edit mode and knob up ten times
      await tester.tap(find.text("72.00"));
      await tester.pumpAndSettle();
      await knobUp(tester, steps: 10);

      // Then the value in the input field is decremented by 10 steps
      assertSettingTextInputValue(forDRF: "Z:BTE200_TEMP", isSetTo: "82.00");
    });
  });
}
