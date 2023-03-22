import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Re-organize Parameters', () {
    testWidgets('Move comment to top of list, should appear at top',
        (tester) async {
      // Given the test page is loaded
      //   the 'G:AMANDA' device is on the page
      //   and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);
      await whenIEnterEditMode(tester);

      // When I move the comment to the top of the page
      //   and I exit edit mode

      // Then the comment is in the top position
    });
  });
}
