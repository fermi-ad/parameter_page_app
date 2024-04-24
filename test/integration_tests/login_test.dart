import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login tests', () {
    testWidgets('Open main menu, logged in as should display the username',
        (WidgetTester tester) async {
      // Given the application has been launched and the user is already logged in
      await startParameterPageApp(tester);

      // When I open the main menu
      await openMainMenu(tester);

      // Then the user's username should be displayed
      assertIsLoggedIn(withUsername: "testuser");
    });

    testWidgets('Tap Logout, user is logged out', (WidgetTester tester) async {
      // Given the application has been launched and the user is already logged in
      await startParameterPageApp(tester);

      // When I logout
      await logout(tester);

      // Then the username changes to "not logged in"
      await openMainMenu(tester);
      assertIsNotLoggedIn();
    });
  });
}
