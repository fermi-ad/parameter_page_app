import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Open Test Page 2 the total number of sub-pages should be 1',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then two tabs are visible:
      assertTabBarContains(nTabs: 2, withTitles: ["Tab 1", "Tab 2"]);
    }, semanticsEnabled: false);
  });
}
