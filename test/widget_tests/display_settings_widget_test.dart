import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

void main() {
  Future<void> changeUnits(tester, {required String to}) async {
    await tester.tap(find.byKey(const Key("display_settings_tile_units")));
    await tester.pumpAndSettle();
    await tester
        .tap(find.byKey(Key("display_settings_tile_units_menuitem_$to")));
    await tester.pumpAndSettle();
  }

  void assertUnits({required String isSetTo}) {
    final tileFinder = find.byKey(const Key('display_settings_tile_units'));
    expect(find.descendant(of: tileFinder, matching: find.text(isSetTo)),
        findsOneWidget);
  }

  Future<void> toggleShowAlarmDetails(tester) async {
    await tester
        .tap(find.byKey(const Key("display_settings_tile_alarm_details")));
    await tester.pumpAndSettle();
  }

  void assertShowAlarmDetails({required String isSetTo}) {
    final tileFinder =
        find.byKey(const Key('display_settings_tile_alarm_details'));
    expect(
        find.descendant(
            of: tileFinder,
            matching: find.text("Show Parameter Alarm Details ($isSetTo)")),
        findsOneWidget);
  }

  group("DisplaySettingsWidget with initialSettings", () {
    testWidgets('Pass settings to constructor, used for initial value',
        (WidgetTester tester) async {
      // Given an initial set of DisplaySettings
      DisplaySettings mySettings =
          DisplaySettings(units: DisplayUnits.primaryUnits);

      // When I initialize the widget with those settings
      MaterialApp myApp = MaterialApp(
          home: Scaffold(
              body: DisplaySettingsWidget(
                  initialSettings: mySettings,
                  onChanged: (DisplaySettings settings) {})));
      await tester.pumpWidget(myApp);

      // Then the units setting shows 'Primary Units'
      assertUnits(isSetTo: "Primary Units");
    });
  });
  group("DisplaySettingsWidget", () {
    late MaterialApp app;

    DisplaySettings newSettings = DisplaySettings();

    setUp(() {
      app = MaterialApp(
          home: Scaffold(
              body: DisplaySettingsWidget(
                  initialSettings: DisplaySettings(),
                  onChanged: (DisplaySettings settings) {
                    newSettings = settings;
                  })));
    });

    testWidgets('Title is Display Settings', (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget
      await tester.pumpWidget(app);

      // Then the app bar title is visible
      expect(find.text("Display Settings"), findsOneWidget);
    });

    testWidgets('Initially, display units is Common Units',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget
      await tester.pumpWidget(app);

      // Then the Units setting shows 'Common Units'
      assertUnits(isSetTo: "Common Units");
    });

    testWidgets('Change Units, form displays new setting',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and the units are set to 'Common Units'
      await tester.pumpWidget(app);
      assertUnits(isSetTo: 'Common Units');

      // When I tap the units tile and change the units to...
      await changeUnits(tester, to: "Primary Units");

      // Then the units setting shows...
      assertUnits(isSetTo: 'Primary Units');
    });

    testWidgets('Change Display Units, onChange is called with new settings',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and the units are set to 'Common Units'
      await tester.pumpWidget(app);
      assertUnits(isSetTo: 'Common Units');

      // When I change the units to "Primary Units"
      await changeUnits(tester, to: "Primary Units");

      // Then the onChange callback is called
      //   and the new settings are stored in settings
      expect(newSettings.units, equals(DisplayUnits.primaryUnits));
    });

    testWidgets('Initially, Show Alarm Details is off',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget
      await tester.pumpWidget(app);

      // Then the Units setting shows 'Common Units'
      assertShowAlarmDetails(isSetTo: "off");
    });

    testWidgets('Change Show Alarm Details, form displays new setting',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and the units are set to 'Common Units'
      await tester.pumpWidget(app);
      assertShowAlarmDetails(isSetTo: 'off');

      // When I toggle the Show Alarm Details setting
      await toggleShowAlarmDetails(tester);

      // Then the Show Alarm Details setting shows...
      assertShowAlarmDetails(isSetTo: 'on');
    });

    testWidgets(
        'Change Show Alarm Details, onChange is called with new settings',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and Show Alarm Details is off
      await tester.pumpWidget(app);
      assertShowAlarmDetails(isSetTo: 'off');

      // When I toggle Show Alarm Details
      await toggleShowAlarmDetails(tester);

      // Then the onChange callback is called
      //   and the new settings are stored in settings
      expect(newSettings.showAlarmDetails, equals(true));
    });
  });
}
