// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameters in Unison (Mults)', () {
    testWidgets(
        'Assign knobbing proportion to parameter, displayed below setting value',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Knob parameter with proportion up multiple steps, proportion applied to each step',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets('Remove mult, parameters are ungrouped',
        (WidgetTester tester) async {
      // Given a parameter page with a mult:3 followed by three parameters
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:3 Test Mult #1");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:MULT3");
      await exitEditMode(tester);
      assertMult(isInRow: 0, hasN: 3, hasDescription: "Test Mult #1");
      assertMultContains(
          atIndex: 0, parameters: ["G:MULT1", "G:MULT2", "G:MULT3"]);

      // When I remove the mult
      await enterEditMode(tester);
      await deleteRow(tester, index: 0);
      await exitEditMode(tester);

      // Then the mult has been removed
      assertParameterIsInRow("G:MULT1", 0);
      assertParameterIsInRow("G:MULT2", 1);
      assertParameterIsInRow("G:MULT3", 2);
    });

    testWidgets(
        'Knob mult without proportions up multiple steps, parameters increment in unison',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult without proportions down multiple steps, parameters decrement in unison',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult with proportions up multiple steps, parameters increment in unison according to proportions',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult with proportions down multiple steps, parameters decrement in unison according according to proportions',
        (WidgetTester tester) async {});

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {});

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {});
  });
}
