import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

void main() {
  group("SettingControlWidget", () {
    testWidgets('Provide no initial value, displays 0.0',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP
      MaterialApp app = const MaterialApp(
          home: Scaffold(
              body: Row(
                  key: Key("parameter_setting_Z:BTE200_TEMP"),
                  children: [SettingControlWidget(drf: "Z:BTE200_TEMP")])));

      // When I display the setting
      await tester.pumpWidget(app);

      // Then 0.0 is displayed
      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_setting_Z:BTE200_TEMP")),
              matching: find.text("0.0")),
          findsOneWidget);
    });

    testWidgets('Provide an initial value, displays that value',
        (WidgetTester tester) async {
      // Given a SettingControlWidget instantiated for a device called Z:BTE200_TEMP
      MaterialApp app = const MaterialApp(
          home: Scaffold(
              body: Row(key: Key("parameter_setting_Z:BTE200_TEMP"), children: [
        SettingControlWidget(drf: "Z:BTE200_TEMP", value: "72.0")
      ])));

      // When I display the setting
      await tester.pumpWidget(app);

      // Then 0.0 is displayed
      expect(
          find.descendant(
              of: find.byKey(const Key("parameter_setting_Z:BTE200_TEMP")),
              matching: find.text("72.0")),
          findsOneWidget);
    });
  });
}
