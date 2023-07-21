import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Send Command', () {
    testWidgets('Expand extended status, show command buttons', (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // When I expand the extended status display for the device
      await expandDigitalStatus(tester, forDRF: "G:AMANDA");

      // Then buttons for the following commands are displayed
      assertCommandButtons(
          areVisible: true,
          forDRF: "G:AMANDA",
          withText: ["Reset", "On", "Off", "Positive", "Negative"]);
    });
  });
}
