// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:go_router/go_router.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/routes.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/services/settings_permission/mock_settings_permission_service.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';
import 'package:parameter_page/services/user_device/mock_user_device_service.dart';
import 'package:parameter_page/services/user_device/system_user_device_service.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/mock_dpm_service.dart';

// Accessible to integration tests
MockDpmService? mockDPMService;
MockParameterPageService? mockParameterPageService;
MockUserDeviceService? mockUserDeviceService;
MockSettingsPermissionService? mockSettingsPermissionService;

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService, deviceService, settingsPermissionService) =
      _configureServices();

  _inhibitF5KeyBrowserReload();

  runFermiApp(
      authInfo: AuthInfo(
          realm: dotenv.env['AUTH_INFO_REALM']!,
          scopes: [],
          clientId: dotenv.env['AUTH_INFO_CLIENT_ID']!,
          clientSecret: dotenv.env['AUTH_INFO_CLIENT_SECRET']!),
      appWidget: ControlsRouterApp(
          title: "Parameter Page",
          router: GoRouter(
              routes: configureRoutes(dpmService, pageService, deviceService,
                  settingsPermissionService))));
}

(
  ACSysServiceAPI,
  ParameterPageService,
  UserDeviceService,
  SettingsPermissionService
) _configureServices() {
  const useMockServices =
      String.fromEnvironment("USE_MOCK_SERVICES", defaultValue: "false") !=
          "false";

  return useMockServices
      ? _configureMockServices()
      : _configureGraphQLServices();
}

(
  ACSysServiceAPI,
  ParameterPageService,
  UserDeviceService,
  SettingsPermissionService
) _configureMockServices() {
  mockDPMService = MockDpmService();
  mockDPMService!.enablePeriodSettingStream();

  mockParameterPageService = MockParameterPageService();

  mockUserDeviceService = MockUserDeviceService();

  mockSettingsPermissionService = MockSettingsPermissionService();

  return (
    mockDPMService!,
    mockParameterPageService!,
    mockUserDeviceService!,
    mockSettingsPermissionService!
  );
}

(
  ACSysServiceAPI,
  ParameterPageService,
  UserDeviceService,
  SettingsPermissionService
) _configureGraphQLServices() {
  return (
    ACSysService(),
    GraphQLParameterPageService(),
    SystemUserDeviceService(),
    MockSettingsPermissionService()
  );
}

void _inhibitF5KeyBrowserReload() {
  html.document.body?.onKeyDown.listen((html.KeyboardEvent event) {
    // Check if the pressed key is F5 (keyCode 116)
    if (event.keyCode == 116) {
      // Prevent default browser behavior
      event.preventDefault();
    }
  });
}
