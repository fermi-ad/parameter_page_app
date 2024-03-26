import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

      // When I tap the mult
      await tapPageEntry(tester, atRowIndex: 0);

      // Then the tapped mult is enabled
      assertMultState(tester, atIndex: 0, isEnabled: true);
    });
  });
}
