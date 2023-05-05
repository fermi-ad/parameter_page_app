import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

void main() {
  group("DisplaySettingsWidget", () {
    late MaterialApp app;

    setUp(() {
      app = const MaterialApp(home: Scaffold(body: DisplaySettingsWidget()));
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
      expect(find.text("Common Units"), findsOneWidget);
    });

    testWidgets('Change Units, form displays new setting',
        (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget and the units are set to 'Common Units'
      await tester.pumpWidget(app);
      expect(find.text('Common Units'), findsOneWidget);

      // When I tap the units tile and change the units to...
      await tester.tap(find.byKey(const Key("display_settings_tile_units")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(
          const Key("display_settings_tile_units_menuitem_Primary Units")));
      await tester.pumpAndSettle();

      // Then the units setting shows...
      expect(find.text('Primary Units'), findsOneWidget);
    });
  });
}
