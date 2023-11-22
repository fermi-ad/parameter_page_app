import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/routes.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/services/user_device/mock_user_device_service.dart';
import 'package:parameter_page/services/user_device/system_user_device_service.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/mock_dpm_service.dart';

// Accessible to integration tests
MockDpmService? mockDPMService;
MockParameterPageService? mockParameterPageService;
MockUserDeviceService? mockUserDeviceService;

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService, deviceService) = _configureServices();

  runApp(ControlsRouterApp(
      title: "Parameter Page",
      router: GoRouter(
          routes: configureRoutes(dpmService, pageService, deviceService))));
}

(ACSysServiceAPI, ParameterPageService, UserDeviceService)
    _configureServices() {
  const useMockServices =
      String.fromEnvironment("USE_MOCK_SERVICES", defaultValue: "false") !=
          "false";

  return useMockServices
      ? _configureMockServices()
      : _configureGraphQLServices();
}

(ACSysServiceAPI, ParameterPageService, UserDeviceService)
    _configureMockServices() {
  mockDPMService = MockDpmService();
  mockDPMService!.enablePeriodSettingStream();

  mockParameterPageService = MockParameterPageService();

  mockUserDeviceService = MockUserDeviceService();

  return (mockDPMService!, mockParameterPageService!, mockUserDeviceService!);
}

(ACSysServiceAPI, ParameterPageService, UserDeviceService)
    _configureGraphQLServices() {
  return (
    ACSysService(),
    GraphQLParameterPageService(),
    SystemUserDeviceService()
  );
}
