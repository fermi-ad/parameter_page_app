import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login tests (work in progress)', () {
    testWidgets('Tap Logout, user is logged out', (WidgetTester tester) async {
      // Given the application has been launched and the user is already logged in
      await startParameterPageApp(tester);

      // When I open the main menu and tap "Logout"
      await openMainMenu(tester);
      await tester.tap(find.text("Logout"));
      await tester.pumpAndSettle();

      // Then the username changes to "not logged in"
      expect(find.text("Logged in as testuser"), findsNothing);
      expect(find.text("You are not logged in"), findsOneWidget);
    });
  });
}
