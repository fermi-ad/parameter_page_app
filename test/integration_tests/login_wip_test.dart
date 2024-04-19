import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login tests (work in progress)', () {
    testWidgets('Open main menu, logged in as should display the username',
        (WidgetTester tester) async {
      // Given test page 1 has been loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I open the main menu
      await openMainMenu(tester);

      // Then the user's username should be displayed
      expect(find.text("Logged in as testuser"), findsOneWidget);
    });
  });
}
