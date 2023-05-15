import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

void main() {
  group("DisplaySettingsWidget", () {
    late MaterialApp app;

    late DisplaySettings newSettings;

    setUp(() {
      app = MaterialApp(home: Scaffold(
          body: DisplaySettingsWidget(onChanged: (DisplaySettings settings) {
        newSettings = settings;
      })));
    });

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

    testWidgets('Change settings, onChange is called with new settings',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and the units are set to 'Common Units'
      await tester.pumpWidget(app);
      assertUnits(isSetTo: 'Common Units');

      // When I change the units to "Primary Units"
      await changeUnits(tester, to: "Primary Units");

      // Then the onChange callback is called
      //   and the new settings are stored in settings
      expect(newSettings.units, equals("Primary Units"));
    });
  });
}
