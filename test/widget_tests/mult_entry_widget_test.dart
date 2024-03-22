import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

import '../integration_tests/helpers/assertions.dart';

void main() {
  group("MultEntryWidget", () {
    testWidgets('Create mult entry, display parameters in entry text',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a MultEntryWidget with n: 0 and description "test mult"
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = const Scaffold(
          body: MultEntryWidget(description: "test mult", numberOfEntries: 0));
      MaterialApp app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the text displayed is "mult:0 test mult"
      expect(find.text("mult:0 test mult"), findsOneWidget);
    });

    testWidgets(
        'Create mult entry, border color matches background color to indicate mult is disabled',
        (WidgetTester tester) async {
      // Given nothing
      await tester.binding.setSurfaceSize(const Size(2560, 1440));

      // When I create a MultEntryWidget
      Scaffold scaffold = const Scaffold(
          body: MultEntryWidget(
              description: "test enable mult", numberOfEntries: 1));
      MaterialApp app = MaterialApp(
          home: scaffold,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
      await tester.pumpWidget(app);

      // Then the mult is in the disabled state
      assertMultState(tester, isEnabled: false);
    });

    testWidgets(
        'Tap mult entry, background color changes to indicate that the mult is accepting input',
        (WidgetTester tester) async {
      // Given a MultEntryWidget with n = 1
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = const Scaffold(
          body: MultEntryWidget(
              description: "test enable mult", numberOfEntries: 1));
      MaterialApp app = MaterialApp(
          home: scaffold,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
      await tester.pumpWidget(app);

      // When I tap the mult entry
      await tester.tap(find.byType(MultEntryWidget));
      await tester.pumpAndSettle();

      // Then the mult is in the enabled state
      assertMultState(tester, isEnabled: true);
    });
  });
}
