// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/routes.dart';
import 'package:parameter_page/services/authorization/acsys_authorization_service.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';
import 'package:parameter_page/services/authorization/mock_authorization_service.dart';
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
MockAuthorizationService? mockAuthorizationService;

void main() async {
  await dotenv.load(fileName: ".env");

  var (
    dpmService,
    pageService,
    deviceService,
    settingsPermissionService,
    authService
  ) = _configureServices();

  _inhibitF5KeyBrowserReload();

  runFermiApp(
      authInfo: authService.authInfo,
      appWidget: AuthRouterApp(
        title: "Parameter Page",
        router: GoRouter(
            redirect: (BuildContext context, GoRouterState state) {
              return "/";
            },
            errorBuilder: (context, state) {
              return Text(state.error!.message);
            },
            routes: configureRoutes(dpmService, pageService, deviceService,
                settingsPermissionService, authService)),
        realm: authService.authInfo!.realm,
        clientId: authService.authInfo!.clientId,
        clientSecret: authService.authInfo!.clientSecret,
      ));
}

(
  ACSysServiceAPI,
  ParameterPageService,
  UserDeviceService,
  SettingsPermissionService,
  AuthorizationService
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
  SettingsPermissionService,
  AuthorizationService
) _configureMockServices() {
  mockDPMService = MockDpmService();
  mockDPMService!.enablePeriodSettingStream();

  mockParameterPageService = MockParameterPageService();

  mockUserDeviceService = MockUserDeviceService();

  mockSettingsPermissionService = MockSettingsPermissionService();

  mockAuthorizationService = MockAuthorizationService();

  return (
    mockDPMService!,
    mockParameterPageService!,
    mockUserDeviceService!,
    mockSettingsPermissionService!,
    mockAuthorizationService!
  );
}

(
  ACSysServiceAPI,
  ParameterPageService,
  UserDeviceService,
  SettingsPermissionService,
  AuthorizationService
) _configureGraphQLServices() {
  return (
    ACSysService(),
    GraphQLParameterPageService(),
    SystemUserDeviceService(),
    MockSettingsPermissionService(),
    ACSysAuthorizationService()
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
