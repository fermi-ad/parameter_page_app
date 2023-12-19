import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/settings_permission/mock_settings_permission_service.dart';
import 'package:parameter_page/widgets/settings_permission_widget.dart';

import '../integration_tests/helpers/assertions.dart';

void main() {
  group("SettingsPermissionWidget", () {
    testWidgets(
        'Settings are disabled, indicator shows that settings are disabled',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // When I render the SettingsPermissionWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // Then the widget is showing that settings are disabled
      assertSettings(areAllowed: false);
    });

    testWidgets(
        'Settings are enabled, indicator shows that settings are enabled',
        (WidgetTester tester) async {
      // Given the user's settings are already enabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      service.enableMockSettings();

      // When I render the SettingsPermissionWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // Then the widget is showing that settings are enabled
      assertSettings(areAllowed: true);
    });

    testWidgets('Request settings for 10 mins, pending status is displayed',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // When I request settings for ten minutes;
      await requestSettingsPermission(
          forDuration: SettingsRequestDuration.tenMinutes);

      // Then the request pending status is shown
      assertSettingsRequestIsPending();
    });
  });
}

Future<void> requestSettingsPermission(
    {required SettingsRequestDuration forDuration}) async {}

enum SettingsRequestDuration { tenMinutes }

void assertSettingsRequestIsPending() {
  expect(
      find.descendant(
          of: find.byKey(const Key("settings-permission")),
          matching: find.text("Requesting settings permission...")),
      findsOneWidget);
}
