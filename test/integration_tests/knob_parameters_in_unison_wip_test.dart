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

    testWidgets(
        'Add entries to an empty mult, display entries inside of new mult',
        (WidgetTester tester) async {
      // Given an empty parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I create a page with a mult:1 containing G:AMANDA
      await addANewEntry(tester, "mult:1 Test Mult #1");
      await addANewEntry(tester, "G:AMANDA");
      await exitEditMode(tester);

      // Then G:AMANDA is shown as part of Test Mult #1
      assertMultContains(atIndex: 0, parameters: ["G:AMANDA"]);
    });

    testWidgets('Remove mult, parameters are ungrouped',
        (WidgetTester tester) async {});

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
