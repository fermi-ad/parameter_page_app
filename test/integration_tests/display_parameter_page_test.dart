import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/main.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Parameter Page', () {
    testWidgets('Display test page, should contain three parameters',
        (tester) async {
      // Given the test page is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

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
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

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
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I wait for the readings to update
      await waitForDataToLoadFor(
          tester, "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE");

      // Then the description and values should be...
      assertParameterHasDetails("PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
    });

    testWidgets(
        "Display ACNET device with only reading property, no setting should be displayed",
        (WidgetTester tester) async {
      //Given test page 1 is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I wait for the data to load
      await waitForDataToLoadFor(tester, "Z:NO_SET");

      // Then there should be no setting property display
      assertParameterHasDetails("Z:NO_SET", readingValue: "100.0");
      assertParameterSettingProperty("Z:NO_SET", isVisible: false);
    });

    testWidgets(
        "Display ACNET device with only setting property, no reading should be displaed",
        (WidgetTester tester) async {
      //Given test page 1 is loaded
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I wait for the data to load
      await waitForDataToLoadFor(tester, "Z:NO_READ");

      // Then there should be no reading property display
      assertParameterHasDetails("Z:NO_READ", settingValue: "50.00");
      assertParameterReadingProperty("Z:NO_READ", isVisible: false);
    });

    testWidgets("Connection failure, should display error message",
        (WidgetTester tester) async {
      // Given test page 1 is loaded
      // ... and getDeviceInfo(..) will fail
      mockDPMService!.getDeviceInfoShouldFail = true;
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // When I wait for the data to load
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");

      // Then an error message should be displayed
      assertParameterInfoError("Z:BTE200_TEMP",
          isVisible: true, messageIs: "Failed to get this parameter");
    });
  });
}
