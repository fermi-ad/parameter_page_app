import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
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
      expect(find.text("Logged in as testuser"), findsOneWidget);
    });
  });
}
