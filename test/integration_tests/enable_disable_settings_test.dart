import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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
  });
}
