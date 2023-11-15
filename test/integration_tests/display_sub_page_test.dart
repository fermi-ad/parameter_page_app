import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets(
        'Open Test Page 2, sub-page navigation should show we are on sub-page 1 of 2',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then there are 2 sub-pages
      assertNumberOfSubPagesIs(2);

      // ... and the current sub-page is 1

      // ... and the sub-page title is "Sub-Page One"
    });
  });
}
