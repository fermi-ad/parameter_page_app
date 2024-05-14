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

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {
      // Given "Test Page 2" has been loaded
      await startParameterPageApp(tester);
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // ... and a mult containing three parameters has been added
      await enterEditMode(tester);
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
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then the mult and the entries that belong to it have persisted
      assertMult(hasN: 3, hasDescription: "test mult");
      assertMultContains(parameters: ["G:MULT1", "G:MULT2", "G:MULT3"]);
    }, semanticsEnabled: false);
  });
}
