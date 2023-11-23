import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Add Comment to Page', () {
    testWidgets('Submit comment, should appear at the top of the page',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I add a new comment...
      await addANewEntry(tester, '!Test comment #1');

      // Then the new comment is added to the page
      assertIsOnPage(comment: 'Test comment #1');
    });
  });
}
