import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> expandAndAssertCommandButtons(tester,
      {required String forDRF, required List<String> haveText}) async {
    await expandDigitalStatus(tester, forDRF: forDRF);
    assertCommandButtons(areVisible: true, forDRF: forDRF, withText: haveText);
    await collapseDigitalStatus(tester, forDRF: forDRF);
  }

  group('Send Command', () {
    testWidgets('Expand extended status, show command buttons', (tester) async {
      // Given the test page is loaded
      app.main();
      await waitForMainPageToLoad(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // When I expand the extended status display for the device
      // Then buttons for the following commands are displayed
      await expandAndAssertCommandButtons(tester,
          forDRF: "G:AMANDA",
          haveText: ["Reset", "On", "Off", "Positive", "Negative"]);
      await expandAndAssertCommandButtons(tester,
          forDRF: "Z:BTE200_TEMP", haveText: ["On", "Off", "Heat", "Cool"]);
    });
  });
}
