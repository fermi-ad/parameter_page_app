import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Change Parameter Alarm Min/Max/Tolerance', () {
    testWidgets('Placeholder', (tester) async {
      // Given
      // When
      // Then
    });

    testWidgets('Initially, Display Settings > Show Alarm Details is OFF',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I navigate to the display settings page
      await navigateToDisplaySettings(tester);

      // Then Units is set to Common
      assertDisplaySettings(isVisible: true);
      assertDisplaySettingsShowAlarmDetails(isOn: false);
    });
  });
}
