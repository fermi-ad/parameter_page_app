import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

void main() {
  MaterialApp initialize(Widget child) {
    return MaterialApp(
        home: Scaffold(
            body: SizedBox(
                key: const Key("parameter_setting_Z:BTE200_TEMP"),
                width: 100.0,
                child: child)));
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
  });
}
