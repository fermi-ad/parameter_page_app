import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Open test page 1, one tab should be visible', (tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 1
      await navigateToTestPage1(tester);

      // Then two tabs are visible:
      assertTabBarContains(nTabs: 1, withTitles: ["Tab 1"]);
    });
  });
}
