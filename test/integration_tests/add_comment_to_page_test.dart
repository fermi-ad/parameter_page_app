import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Add Comment to Page', () {
    testWidgets('Submit comment, should appear at the top of the page',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
    });
  });
}
