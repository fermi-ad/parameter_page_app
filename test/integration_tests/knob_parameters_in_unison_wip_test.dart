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
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

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
      assertMult(isInRow: 0, hasN: 3, hasDescription: "test mult");
      assertMultContains(
          atIndex: 0, parameters: ["G:MULT1", "G:MULT2", "G:MULT3"]);
    }, semanticsEnabled: false);

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);
  });
}
