import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create New Parameter Page', () {
    testWidgets('Tap New Page, should be presented with a new blank page',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I press new page and add some new entries
      await newPage(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, "A comment");
      await exitEditMode(tester);
      await enterEditMode(tester);
      await addANewParameter(tester, "M:OUTTMP");
      await exitEditMode(tester);

      // Then the page is empty
      assertNumberOfEntriesOnPageIs(2);
      assertParameterIsInRow("M:OUTTMP", 1);
    });
  });
}
