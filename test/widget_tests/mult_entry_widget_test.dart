import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

import '../integration_tests/helpers/assertions.dart';

void main() {
  group("MultEntryWidget", () {
    testWidgets('Create mult entry, display parameters in entry text',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a MultEntryWidget with n: 0 and description "test mult"
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = Scaffold(
          body: MultEntryWidget(
        description: "test mult",
        numberOfEntries: 0,
        displaySettings: DisplaySettings(),
      ));
      MaterialApp app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the text displayed is "mult:0 test mult"
      expect(find.text("mult:0 test mult"), findsOneWidget);
    });

    testWidgets(
        'Create mult entry with editMode = true, only text is displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a MultEntryWidget with editMode: true
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = Scaffold(
          body: MultEntryWidget(
              description: "test mult",
              numberOfEntries: 0,
              editMode: true,
              displaySettings: DisplaySettings()));
      MaterialApp app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the text displayed is "mult:0 test mult"
      expect(find.text("mult:0 test mult"), findsOneWidget);

      // ... but there is no Card (only used in display mode)
      expect(
          find.descendant(
              of: find.byType(MultEntryWidget), matching: find.byType(Card)),
          findsNothing);

      // .. and no InkWell
      expect(
          find.descendant(
              of: find.byType(MultEntryWidget), matching: find.byType(InkWell)),
          findsNothing);
    });

    testWidgets(
        'Create mult entry, border color matches background color to indicate mult is disabled',
        (WidgetTester tester) async {
      // Given nothing
      await tester.binding.setSurfaceSize(const Size(2560, 1440));

      // When I create a MultEntryWidget
      Scaffold scaffold = Scaffold(
          body: MultEntryWidget(
              description: "test enable mult",
              numberOfEntries: 1,
              displaySettings: DisplaySettings()));
      MaterialApp app = MaterialApp(
          home: scaffold,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
      await tester.pumpWidget(app);

      // Then the mult is in the disabled state
      assertMultState(tester, atIndex: 0, isEnabled: false);
    });

    testWidgets(
        'Create mult entry with enabled:true, border is highlighted to indicate mult is enabled',
        (WidgetTester tester) async {
      // Given nothing
      await tester.binding.setSurfaceSize(const Size(2560, 1440));

      // When I create a MultEntryWidget with enabled: true
      Scaffold scaffold = Scaffold(
          body: MultEntryWidget(
              description: "test enable mult",
              numberOfEntries: 1,
              enabled: true,
              displaySettings: DisplaySettings()));
      MaterialApp app = MaterialApp(
          home: scaffold,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
      await tester.pumpWidget(app);

      // Then the mult is in the enabled state
      assertMultState(tester, atIndex: 0, isEnabled: true);
    });
  });
}
