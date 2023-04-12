import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Add Parameter to Page', () {
    testWidgets(
        'Submit ACNET parameter, should appear at the bottom of the page',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      app.main();
      await tester.pumpAndSettle();
      await enterEditMode(tester);

      // When I add a new ACNET parameter...
      await addANewParameter(tester, 'Z:BDCCT');
      await exitEditMode(tester);

      // Then the new parameter is added to the page
      assertParameterIsInRow("Z:BDCCT", 5);
      assertParameterHasDetails("Z:BDCCT",
          description: "Booster DCCT",
          settingValue: "50.00",
          readingValue: "100.0");
    });
  });
}
