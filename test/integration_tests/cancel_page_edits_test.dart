import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cancel Page Edits', () {
    testWidgets(
        'Move parameter to top of list and cancel, parameter should return to original position',
        (tester) async {
      // Given the test page is loaded
      //   the 'G:AMANDA' device is on the page
      //   in row 3
      //   and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);
      assertParameterIsInRow("G:AMANDA", 2);
      await enterEditMode(tester);

      // When I move the parameter to the top of the page
      //   and I exit edit mode
      await moveRowAtIndexNRowsUp(tester, 2, 2);
      await cancelEditMode(tester);

      // Then the comment is in the top position
      assertParameterIsInRow("G:AMANDA", 2);
    });
  });
}
