import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';

import 'helpers/actions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login tests (work in progress)', () {
    testWidgets('Tap Login, user is authenticated',
        (WidgetTester tester) async {
      // Given the application has been launched and the user is not logged in
      await startParameterPageApp(tester);
      await openMainMenu(tester);
      await tester.tap(find.text("Logout"));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(LandingPageWidget));
      await tester.pumpAndSettle();

      // When I open the main menu and tap "Login"
      await openMainMenu(tester);
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      // Then the username changes to "testuser"
      expect(find.text("You are not logged in"), findsNothing);
      expect(find.text("testuser"), findsOneWidget);
    });
  });
}
