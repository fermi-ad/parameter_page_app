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

    testWidgets('Tap outside of enabled mult, disable mult',
        (WidgetTester tester) async {
      // Given a new parameter page with a mult entry
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:0 test mult #1");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // ... and test mult #1 is already enabled
      await tapPageEntry(tester, atRowIndex: 0);

      // When I tap outside of the mult
      await tester.tap(find.text("New Parameter Page"));

      // Then the mult is in the disabled state
      assertMultState(tester, atIndex: 0, isEnabled: false);
    });

    testWidgets(
        'Add entries to an empty mult, display entries inside of new mult',
        (WidgetTester tester) async {});

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
