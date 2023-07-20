import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Display test page, should contain three parameters',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // Then the following parameters should be displayed...
      assertParametersAreOnPage([
        "M:OUTTMP@e,02",
        "G:AMANDA",
        "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE"
      ]);
    });

    testWidgets(
        'Display ACNET device, should contain parameter details with setting and reading values',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I wait for the parametr data to update
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the descript and reading values should be...
      assertParameterHasDetails("M:OUTTMP@e,02",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
      assertParameterHasDetails("G:AMANDA",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
    });

    testWidgets(
        "Display PV, should contain parameter details with setting and reading values",
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I wait for the readings to update
      await waitForDataToLoadFor(
          tester, "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE");

      // Then the description and values should be...
      assertParameterHasDetails("PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
    });
  });
}
