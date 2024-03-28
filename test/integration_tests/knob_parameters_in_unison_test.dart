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
        'Create an empty mult, empty mult entry is shown with description',
        (WidgetTester tester) async {
      // Given a blank parameter page in edit mode
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I add a mult with N = 0 and a description of 'test mult' (mult:0 test mult)
      await addANewEntry(tester, "mult:0 test mult");

      // ... and I exit edit mode
      await exitEditMode(tester);

      // Then the empty mult is displayed
      assertMult(isInRow: 0, hasN: 0, hasDescription: "test mult");

      // ... and it contains no parameters
      assertMultContains(atIndex: 1, parameters: []);
    });

    testWidgets('Tap mult, mult is enabled for knobbing',
        (WidgetTester tester) async {
      // Given a new parameter page with a mult entry in position 0
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:0 test mult");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the mult
      await tapPageEntry(tester, atRowIndex: 0);

      // Then the tapped mult is enabled
      assertMultState(tester, atIndex: 0, isEnabled: true);
    });

    testWidgets(
        'Tap another mult while knobbing a different mult, tapped mult is enabled and previous mult is disabled',
        (WidgetTester tester) async {
      // Given a new parameter page with two mult entries
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:0 test mult #1");
      await addANewEntry(tester, "mult:0 test mult #2");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // ... and test mult #1 is already enabled
      await tapPageEntry(tester, atRowIndex: 0);

      // When I tap test mult #2
      await tapPageEntry(tester, atRowIndex: 1);

      // Then test mult #2 is enabled
      assertMultState(tester, atIndex: 1, isEnabled: true);

      // ... and test mult #1 is disabled
      assertMultState(tester, atIndex: 0, isEnabled: false);
    });

    testWidgets('Tap an enabled mult, mult is disabled',
        (WidgetTester tester) async {
      // Given a new parameter page with a single mult entry
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:0 test mult #1");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // ... and test mult #1 is already enabled
      await tapPageEntry(tester, atRowIndex: 0);

      // When I tap test mult #1 again
      await tapPageEntry(tester, atRowIndex: 0);

      // Then test mult #1 is disabled
      assertMultState(tester, atIndex: 0, isEnabled: false);
    });

    testWidgets('Setting disabled, mult won\'t receive focus',
        (WidgetTester tester) async {
      // Given a new parameter page with a mult entry in position 0
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:0 test mult");
      await exitEditMode(tester);

      // ... and settings are disabled
      assertSettings(areAllowed: false);

      // When I tap the mult
      await tapPageEntry(tester, atRowIndex: 0);

      // Then the tapped mult is still disabled
      assertMultState(tester, atIndex: 0, isEnabled: false);
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
      await tester.pumpAndSettle();

      // Then the mult is in the disabled state
      assertMultState(tester, atIndex: 0, isEnabled: false);
    });
  });
}
