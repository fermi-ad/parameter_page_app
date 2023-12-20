import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/settings_permission/mock_settings_permission_service.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';
import 'package:parameter_page/widgets/settings_permission_widget.dart';

import '../integration_tests/helpers/actions.dart';
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
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.tenMinutes);

      // Then the request pending status is shown
      assertSettingsRequestIsPending();

      // Clean-up
      await waitForSettingsPermissionRequest(tester);
    });

    testWidgets('Request for settings is approved, enable status is displayed',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // When I request settings for ten minutes
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.tenMinutes);

      // ... and wait for the status to be returned
      await waitForSettingsPermissionRequest(tester);

      // Then the widget indicates that settings are approved
      assertSettings(areAllowed: true);
    });

    testWidgets('Request for settings is denied, disabled status is displayed',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // ... and for whatever reason we are not allowed to do settings
      service.mockDenySettingsPermissionRequests = true;

      // When I request settings for ten minutes
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.tenMinutes);

      // ... and wait for the status to be returned
      await waitForSettingsPermissionRequest(tester);

      // Then the widget indicates that settings are approved
      assertSettings(areAllowed: true);
    });
  });
}

Future<void> waitForSettingsPermissionRequest(WidgetTester tester) async {
  await pumpUntilGone(tester, find.text("Request pending..."));
}

Future<void> requestSettingsPermission(WidgetTester tester,
    {required SettingsRequestDuration forDuration}) async {
  final widgetFinder = find.byKey(const Key("settings-permission"));

  await tester.tap(find.descendant(
      of: widgetFinder, matching: find.byIcon(Icons.expand_more)));
  await tester.pumpAndSettle();

  switch (forDuration) {
    case SettingsRequestDuration.tenMinutes:
      await tester.tap(find.text("10 Minutes"));
      break;

    case SettingsRequestDuration.oneHour:
      await tester.tap(find.text("1 Hour"));
      break;

    case SettingsRequestDuration.eightHours:
      await tester.tap(find.text("8 Hours"));
  }
  await tester.pumpAndSettle();
}

void assertSettingsRequestIsPending() {
  expect(
      find.descendant(
          of: find.byKey(const Key("settings-permission")),
          matching: find.text("Request pending...")),
      findsOneWidget);
}
