import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class SettingsPermissionService {
  bool get settingsAllowed;
}

class MockSettingsPermissionService implements SettingsPermissionService {
  @override
  bool get settingsAllowed {
    return false;
  }
}

class SettingsPermissionWidget extends StatelessWidget {
  const SettingsPermissionWidget(
      {super.key, required SettingsPermissionService service});

  @override
  Widget build(BuildContext context) {
    return Container(key: const Key("settings-permission"));
  }
}

void main() {
  group("SettingsPermissionWidget", () {
    testWidgets(
        'Settings are disabled, indicator shows that settings are disabled',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      expect(service.settingsAllowed, false);

      // When I render the SettingsPermissionWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // Then the widget is showing that settings are disabled
      _assertSettings(areEnabled: false);
    });
  });
}

void _assertSettings({required bool areEnabled}) {
  final widgetFinder = find.byKey(const Key("settings-permission"));

  final disabledTextFinder = find.text("Disabled");

  final disabledIndicatorFinder =
      find.byKey(const Key("settings-permission-indicator-disabled"));

  expect(find.descendant(of: widgetFinder, matching: disabledTextFinder),
      areEnabled ? findsNothing : findsOneWidget);

  expect(find.descendant(of: widgetFinder, matching: disabledIndicatorFinder),
      areEnabled ? findsNothing : findsOneWidget);
}
