import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Enable/Disable Settings', () {
    testWidgets('Initially, settings are disabled',
        (WidgetTester tester) async {
      // Given the parameter page is started and I have test page 1 open
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);

      // Then the settings are disabled
      assertSettings(areAllowed: false);
    }, semanticsEnabled: false);

    testWidgets('Settings disabled, change a setting property is inhibited',
        (WidgetTester tester) async {
      // Given the test page is loaded and settings are disabled
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      assertSettings(areAllowed: false);

      // When I tap the setting property
      await tapSetting(tester, forDRF: "Z:BTE200_TEMP");

      // Then the the setting text input does not activate
      assertSettingTextInput(forDRF: "Z:BTE200_TEMP", isVisible: false);
    });

    testWidgets('Settings disabled, sending a command is inhibited',
        (WidgetTester tester) async {
      // Given the test page is loaded and settings are disabled
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "Z:BTE200_TEMP");
      assertSettings(areAllowed: false);

      // When I open the expanded digital status for G:AMANDA
      await expandDigitalStatus(tester, forDRF: "G:AMANDA");

      // Then the command buttons are inhibited
      assertCommandButtonsAreDisabled(tester,
          forDRF: "G:AMANDA",
          withText: ["Reset", "On", "Off", "Positive", "Negative"]);
    });
  });
}
