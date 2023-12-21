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

    testWidgets('Request for settings fails, previous status is displayed',
        (WidgetTester tester) async {
      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // ... and for whatever reason the request will fail
      service.mockFailSettingsPermissionRequests = true;

      // When I request settings for ten minutes
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.tenMinutes);

      // ... and wait for the status to be returned
      await waitForSettingsPermissionRequest(tester);

      // Then the widget indicates that settings are still disabled
      assertSettings(areAllowed: false);

      // ... and the error message is displayed
      expect(
          find.text(
              "Request failed - Fake settings permission request failure."),
          findsOneWidget);
    });

    testWidgets('Settings are enabled, Disable is an option in pop-up menu',
        (WidgetTester tester) async {
      // Given the user's settings are enabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      service.enableMockSettings();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // When I open the settings permission menu
      await openSettingsPermissionMenu(tester);

      // Then 'Disable settings' is an option in the pop-up menu
      assertDisableSettingsMenuEntry(isVisible: true);
    });

    testWidgets('Disable settings, status goes to pending first',
        (WidgetTester tester) async {
      // Given the user's settings are enabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      service.enableMockSettings();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // When I request settings for ten minutes;
      await requestSettingsPermissionBeDisabled(tester);

      // Then the request pending status is shown
      assertSettingsRequestIsPending();

      // Clean-up
      await waitForSettingsPermissionRequest(tester);
    });

    testWidgets('Disable settings, status goes to pending and then disabled',
        (WidgetTester tester) async {
      // Given the user's settings are enabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      service.enableMockSettings();

      // ... and the SettingsPermissionWidget has been rendered
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SettingsPermissionWidget(service: service)));
      await tester.pumpWidget(app);

      // When I request settings for ten minutes;
      await requestSettingsPermissionBeDisabled(tester);

      // ... and wait for the request to finish
      await waitForSettingsPermissionRequest(tester);

      // Then the settings are disabled
      assertSettings(areAllowed: false);
    });

    testWidgets(
        'Enable settings, onChanged: callback is invoked with settingsAllowed = true',
        (WidgetTester tester) async {
      bool? settingsAllowed;

      // Given the user's settings are disabled
      MockSettingsPermissionService service = MockSettingsPermissionService();

      // ... and the SettingsPermissionWidget has been rendered with an onChange call-back
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SettingsPermissionWidget(
                  service: service,
                  onChanged: (bool newSettingsAllowed) =>
                      settingsAllowed = newSettingsAllowed)));
      await tester.pumpWidget(app);

      // When I enable settings for ten minutes
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.tenMinutes);

      // ... and wait for the request to be granted
      await waitForSettingsPermissionRequest(tester);

      // Then onChange was called will settingsAllowed = true
      expect(settingsAllowed, true);
    });

    testWidgets(
        'Disable settings, onChanged: callback is invoked with settingsAllowed = false',
        (WidgetTester tester) async {
      bool? settingsAllowed;

      // Given the user's settings are enabled
      MockSettingsPermissionService service = MockSettingsPermissionService();
      service.enableMockSettings();

      // ... and the SettingsPermissionWidget has been rendered with an onChange call-back
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SettingsPermissionWidget(
                  service: service,
                  onChanged: (bool newSettingsAllowed) =>
                      settingsAllowed = newSettingsAllowed)));
      await tester.pumpWidget(app);

      // When I disable settings
      await requestSettingsPermissionBeDisabled(tester);

      // ... and wait for the request to be granted
      await waitForSettingsPermissionRequest(tester);

      // Then onChange was called will settingsAllowed = false
      expect(settingsAllowed, false);
    });
  });
}

void assertDisableSettingsMenuEntry({required bool isVisible}) {
  expect(
      find.text("Disable settings"), isVisible ? findsOneWidget : findsNothing);
}

void assertSettingsRequestIsPending() {
  expect(find.text("Request pending..."), findsOneWidget);
}
