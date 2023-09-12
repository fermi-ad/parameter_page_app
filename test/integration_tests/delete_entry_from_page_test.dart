import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Delete Entry from Page', () {
    testWidgets('Click delete, should delete entry', (tester) async {
      // Given the test page is loaded
      //    the 'G:AMANDA' device is on the page
      //    and I am in the edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["G:AMANDA"]);
      await enterEditMode(tester);

      // When I delete the parameter entry...
      await deleteRow(tester, index: 2);

      // Then the parameter should be removed from the page
      assertParametersAreNotOnPage(["G:AMANDA"]);
    });
  });
}
