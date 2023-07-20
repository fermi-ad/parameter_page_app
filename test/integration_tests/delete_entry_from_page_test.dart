import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Delete Entry from Page', () {
    testWidgets('Confirm no, should not delete entry', (tester) async {
      // Given the test page is loaded
      //   the 'G:AMANDA' device is on the page
      //   and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);
      await enterEditMode(tester);

      // When I attempt to delete the parameter entry but select No from the confirmation dialog...
      await deleteRow(tester, index: 2, confirm: false);

      // Then the parameter is still on the page
      assertParametersAreOnPage(["G:AMANDA"]);
    });

    testWidgets('Confirm yes, should delete entry', (tester) async {
      // Given the test page is loaded
      //    the 'G:AMANDA' device is on the page
      //    and I am in the edit mode
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);
      await enterEditMode(tester);

      // When I delete the parameter entry...
      await deleteRow(tester, index: 2);

      // Then the parameter should be removed from the page
      assertParametersAreNotOnPage(["G:AMANDA"]);
    });
  });
}
