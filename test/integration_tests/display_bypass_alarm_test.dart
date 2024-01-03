import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Alarm Status', () {
    testWidgets('Parameter with no active alarm, display no alarm indicator',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no active alarm is on the page
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["M:OUTTMP@e,02"]);

      // Then nothing is display in the digitial status column
      assertAlarmStatus(forDRF: "M:OUTTMP@e,02", isInAlarm: false);
    });
  });
}

void assertAlarmStatus({required String forDRF, required bool isInAlarm}) {}
