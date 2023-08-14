import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Re-organize Parameters', () {
    testWidgets('Move parameter to top of list, should appear at top',
        (tester) async {
      // Given the test page is loaded
      //   the 'G:AMANDA' device is on the page
      //   in row 3
      //   and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["G:AMANDA"]);
      assertParameterIsInRow("G:AMANDA", 2);
      await enterEditMode(tester);

      // When I move the parameter to the top of the page
      //   and I exit edit mode
      await moveRowAtIndexNRowsUp(tester, 2, 2);
      await exitEditMode(tester);

      // Then the comment is in the top position
      assertParameterIsInRow("G:AMANDA", 0);
    });

    testWidgets(
        'Move entry down two rows, should remove from old position and insert at new position',
        (tester) async {
      // Given the test page is loaded, "G:AMANDA" is in row 3 and edit mode is enabled
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParameterIsInRow("G:AMANDA", 2);
      await enterEditMode(tester);

      // When I move the parameter down by 1 row...
      await moveRowAtIndexNRowsDown(tester, 2, 1);

      // Then the parameter appears in the new row...
      assertParameterIsInRow("G:AMANDA", 3);
    });
  });
}
