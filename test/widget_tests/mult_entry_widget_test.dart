import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/services/dpm/mock_dpm_service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

import '../integration_tests/helpers/actions.dart';
import '../integration_tests/helpers/assertions.dart';

void main() {
  group("MultEntryWidget", () {
    testWidgets('Create mult entry, display parameters in entry text',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a MultEntryWidget with n: 0 and description "test mult"
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
        description: "test mult",
        numberOfEntries: 0,
        entries: const [],
        displaySettings: DisplaySettings(),
      ));
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
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
              description: "test mult",
              numberOfEntries: 0,
              editMode: true,
              entries: const [],
              displaySettings: DisplaySettings()));
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
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
              description: "test enable mult",
              numberOfEntries: 1,
              entries: [ParameterEntry("G:MULT1")],
              displaySettings: DisplaySettings()));
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
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
              description: "test enable mult",
              numberOfEntries: 1,
              entries: [ParameterEntry("G:MULT1")],
              enabled: true,
              displaySettings: DisplaySettings()));
      await tester.pumpWidget(app);

      // Then the mult is in the enabled state
      assertMultState(tester, atIndex: 0, isEnabled: true);
    });

    testWidgets(
        'Create mult entry containing 3 parameters, three ParameterWidgets are rendered inside of a MultEntryWidget',
        (WidgetTester tester) async {
      // Given nothing
      await tester.binding.setSurfaceSize(const Size(2560, 1440));

      // When I create a MultEntryWidget containing three parameters...
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
              description: "Test Mult #1",
              numberOfEntries: 3,
              entries: [
                ParameterEntry("G:MULT0"),
                ParameterEntry("G:MULT1"),
                ParameterEntry("G:MULT2")
              ],
              enabled: false,
              displaySettings: DisplaySettings()));
      await tester.pumpWidget(app);

      // Then a ParameterWidget is rendered for the 3 parameters inside of a MultEntryWidget
      assertMult(isInRow: 0, hasN: 3, hasDescription: "Test Mult #1");
      assertMultState(tester, atIndex: 0, isEnabled: false);
      assertMultContains(
          atIndex: 0, parameters: ["G:MULT0", "G:MULT1", "G:MULT2"]);
    });

    testWidgets('Enable mult entry and knob up, onKnobUp is called',
        (WidgetTester tester) async {
      bool wasKnobbedUp = false;

      // Given a MultEntryWidget has been built with a onKnobUp handler
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      MaterialApp app = _buildMaterialApp(
          child: MultEntryWidget(
              onKnobUp: () => wasKnobbedUp = true,
              description: "Test Mult #1",
              numberOfEntries: 3,
              entries: [
                ParameterEntry("G:MULT0"),
                ParameterEntry("G:MULT1"),
                ParameterEntry("G:MULT2")
              ],
              enabled: false,
              displaySettings: DisplaySettings()));
      await tester.pumpWidget(app);

      // When I knob up by 1
      await knobUp(tester, steps: 1);

      // Then the onKnobUp handler was called
      expect(wasKnobbedUp, true, reason: "onKnobUp was not invoked");
    });
  });
}

MaterialApp _buildMaterialApp({required Widget child}) {
  Scaffold scaffold = Scaffold(
      body: DataAcquisitionWidget(
          service: MockDpmService(useEmptyStream: true), child: child));
  return MaterialApp(
      home: scaffold,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
}
