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
      assertMult(hasN: 0, hasDescription: "test mult");

      // ... and it contains no parameters
      assertMultContains(parameters: []);
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
      assertMultContains(parameters: ["G:AMANDA"]);
    });

    testWidgets('Add mult:1 and a parameter, both are shown in edit mode list',
        (WidgetTester tester) async {
      // Given an empty parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I create a page with a mult:1 containing G:AMANDA
      await addANewEntry(tester, "mult:1 Test Mult #1");
      await addANewEntry(tester, "G:AMANDA");

      // Then there should be two entires on the page
      assertMult(hasN: 1, hasDescription: "Test Mult #1");
      assertParameterIsInRow("G:AMANDA", 1);
    });

    testWidgets('Exit/re-enter/exit edit mode, no duplicate key errors',
        (WidgetTester tester) async {
      // Given I have created a new parameter page with a mult:1 and a parameter
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:1 Test Mult #1");
      await addANewEntry(tester, "G:AMANDA");

      // When I exit edit mode, re-enter and exit again
      await exitEditMode(tester);
      await enterEditMode(tester);
      await exitEditMode(tester);

      // Then there should be two entires on the page
      assertMult(hasN: 1, hasDescription: "Test Mult #1");
      assertParameterIsInRow("G:AMANDA", 1);
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
      assertMult(hasN: 3, hasDescription: "Test Mult #1");
      assertMultContains(parameters: ["G:MULT1", "G:MULT2", "G:MULT3"]);

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
        (WidgetTester tester) async {
      // Given a parameter page with a mult:3 followed by three parameters
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:3 Test Mult #1");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:MULT3");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // .. and the settings data has loaded
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");

      // When I tap the mult and knob up 4 times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobUp(tester, steps: 4);

      // Then the settings for each parameter belonging to the mult have been increment in unison
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "50.02");
      assertParameterHasDetails("G:MULT2", settingValue: "50.02");
      assertParameterHasDetails("G:MULT3", settingValue: "50.02");
    });

    testWidgets(
        'Knob mult without proportions down multiple steps, parameters decrement in unison',
        (WidgetTester tester) async {
      // Given a parameter page with a mult:3 followed by three parameters
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);
      await addANewEntry(tester, "mult:3 Test Mult #1");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:MULT3");
      await exitEditMode(tester);

      // ... and settings have been enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // .. and the settings data has loaded
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");

      // When I tap the mult and knob up 4 times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobDown(tester, steps: 4);

      // Then the settings for each parameter belonging to the mult have been increment in unison
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "49.98");
      assertParameterHasDetails("G:MULT2", settingValue: "49.98");
      assertParameterHasDetails("G:MULT3", settingValue: "49.98");
    });

    testWidgets(
        'Knob mult with proportions up multiple steps, parameters increment in unison according to proportions',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... with a mult and three parameters assigned varying proportions
      await addANewEntry(tester, "mult:3");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2*200");
      await addANewEntry(tester, "G:MULT3*-200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");
      await waitForDataToLoadFor(tester, "G:MULT2");
      await waitForDataToLoadFor(tester, "G:MULT3");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the mult and knob up ten times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobUp(tester, steps: 10);

      // Then the values displayed are...
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "50.05");
      assertParameterHasDetails("G:MULT2", settingValue: "60.00");
      assertParameterHasDetails("G:MULT3", settingValue: "40.00");
    }, semanticsEnabled: false);

    testWidgets(
        'Knob mult with proportions down multiple steps, parameters decrement in unison according according to proportions',
        (WidgetTester tester) async {
      // Given a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... with a mult and three parameters assigned varying proportions
      await addANewEntry(tester, "mult:3");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2*200");
      await addANewEntry(tester, "G:MULT3*-200");
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "G:MULT1");
      await waitForDataToLoadFor(tester, "G:MULT2");
      await waitForDataToLoadFor(tester, "G:MULT3");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the mult and knob up ten times
      await tapPageEntry(tester, atRowIndex: 0);
      await knobDown(tester, steps: 10);

      // Then the values displayed are...
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT1");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT2");
      await waitForSettingDataToLoad(tester, forDRF: "G:MULT3");
      assertParameterHasDetails("G:MULT1", settingValue: "49.95");
      assertParameterHasDetails("G:MULT2", settingValue: "40.00");
      assertParameterHasDetails("G:MULT3", settingValue: "60.00");
    }, semanticsEnabled: false);
  });

  testWidgets('Save new page containing mults, mults are persisted',
      (WidgetTester tester) async {
    // Given a new parameter page titled "New Page With Mult" with a mult containing three parameters
    await startParameterPageApp(tester);
    await createNewParameterPage(tester);
    await changePageTitle(tester, to: "New Page With Mult");
    await addANewEntry(tester, "mult:3 test mult");
    await addANewEntry(tester, "G:MULT1");
    await addANewEntry(tester, "G:MULT2");
    await addANewEntry(tester, "G:MULT3");
    await exitEditMode(tester);

    // When I save the new page, start a new page and then open the saved page again
    await openMainMenu(tester);
    await saveParameterPage(tester);
    await waitForPageToBeSaved(tester);
    await newPage(tester);
    await navigateToOpenPage(tester);
    await openParameterPage(tester, withTitle: "New Page With Mult");

    // Then the page contains the mults and the three parameters that belong to it
    assertMult(hasN: 3, hasDescription: "test mult");
    assertMultContains(parameters: ["G:MULT1", "G:MULT2", "G:MULT3"]);
  }, semanticsEnabled: false);
}
