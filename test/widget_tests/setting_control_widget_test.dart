import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

void main() {
  MaterialApp initialize(Widget child) {
    return MaterialApp(
        home: Scaffold(
            body: Row(
                key: const Key("parameter_setting_Z:BTE200_TEMP"),
                children: [child])));
  }

  void assertSettingDisplay({required bool isVisible, String? value}) {
    if (isVisible) {
      expect(find.byKey(const Key("parameter_settingdisplay_Z:BTE200_TEMP")),
          findsOneWidget);
    }

    if (isVisible && value != null) {
      expect(
          find.descendant(
              of: find
                  .byKey(const Key("parameter_settingdisplay_Z:BTE200_TEMP")),
              matching: find.text(value)),
          findsOneWidget);
    }
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
  });
}
