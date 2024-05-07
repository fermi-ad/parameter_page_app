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
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // Given I have loaded Test Page 2
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and I have added 4 parameters with proportions
      await enterEditMode(tester);
      await addANewEntry(tester, "G:MULT1*1");
      await addANewEntry(tester, "G:MULT2*-1");
      await addANewEntry(tester, "G:MULT3*2.5");
      await addANewEntry(tester, "G:MULT4*0.2");
      await exitEditMode(tester);

      // When I save the page, start a new page and then reload it
      await openMainMenu(tester);
      await saveParameterPage(tester);
      await waitForPageToBeSaved(tester);
      await newPage(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then the knobbing proportions are still assigned
      assertKnobbingProportion(forDRF: "I:BEAM", isVisible: false);
      assertKnobbingProportion(forDRF: "R:BEAM", isVisible: false);
      assertKnobbingProportion(forDRF: "G:MULT1", isVisible: false);
      assertKnobbingProportion(forDRF: "G:MULT2", isVisible: true);
      assertParameterHasDetails("G:MULT2", proportion: "-1.0");
      assertKnobbingProportion(forDRF: "G:MULT3", isVisible: true);
      assertParameterHasDetails("G:MULT3", proportion: "2.5");
      assertKnobbingProportion(forDRF: "G:MULT4", isVisible: true);
      assertParameterHasDetails("G:MULT4", proportion: "0.2");
    }, semanticsEnabled: false);

    testWidgets(
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);
  });
}
