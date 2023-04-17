import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cancel Page Edits', () {
    testWidgets('Outside edit mode, cancel button is not visible',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      await enterEditMode(tester);

      // When I exit edit mode
      await exitEditMode(tester);

      // Then the cancel button is not visible
      assertEditModeCancelButton(isVisible: false);
    });

    testWidgets('Inside edit mode, cancel button is visible', (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I enter edit mode
      await enterEditMode(tester);

      // Then the cancel button is visible
      assertEditModeCancelButton(isVisible: true);
    });

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

      // Then the parameter returns to it's original position in row 3
      assertParameterIsInRow("G:AMANDA", 2);
    });

    testWidgets(
        'Delete multiple entries and cancel, all deletes should be discarded',
        (tester) async {
      // Given the test page is loaded
      //   the 'G:AMANDA' device is on the page
      //   in row 3
      //   and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      assertParameterIsInRow("M:OUTTMP@e,02", 0);
      assertParameterIsInRow("G:AMANDA", 2);
      await enterEditMode(tester);

      // When I delete two parameters
      //   and I exit edit mode
      await deleteRow(tester, index: 0);
      await deleteRow(tester, index: 2);
      await cancelEditMode(tester);

      // Then the parameters return to their original positions
      assertParameterIsInRow("M:OUTTMP@e,02", 0);
      assertParameterIsInRow("G:AMANDA", 2);
    });

    testWidgets('Add comment and cancel, new comment should be discarded',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      await enterEditMode(tester);

      // When I add a new comment and cancel edit mode
      const badComment = "I don't want to see this comment";
      await addANewComment(tester, badComment);
      await cancelEditMode(tester);

      // Then the parameters return to their original positions
      assertIsNotOnPage(comment: badComment);
    });
  });
}
