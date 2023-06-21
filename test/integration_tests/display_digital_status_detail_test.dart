import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Digital Status Detail', () {
    testWidgets(
        'Parameter with no digitial status, should display nothing in the status colum',
        (tester) async {
      // Then nothing is display in the digitial status column
    });

    testWidgets(
        'Tapping paramter with no digital status, should not do anything',
        (tester) async {
      // Given the test page is loaded
      //   and the 'M:OUTTMP' device is on the page in row 1
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);

      // When I tap the M:OUTTMP row
      await tapPageEntry(tester, atRowIndex: 2);

      // Then nothing happens
      assertConfirmDeleteDialog(isVisible: false);
    });
  });
}
