import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/routes.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/widgets/fermi_controls_common/fermi_controls_app.dart';
import 'services/dpm/dpm_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/graphql_dpm_service.dart';
import 'services/dpm/mock_dpm_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService) = _configureServices();

  runApp(FermiControlsApp(
      title: "Parameter Page",
      router: GoRouter(routes: configureRoutes(dpmService, pageService))));
}

(DpmService, ParameterPageService) _configureServices() {
  const useMockServices =
      String.fromEnvironment("USE_MOCK_SERVICES", defaultValue: "false") !=
          "false";

  return useMockServices
      ? _configureMockServices()
      : _configureGraphQLServices();
}

(DpmService, ParameterPageService) _configureMockServices() {
  MockDpmService dpm = MockDpmService();
  dpm.enablePeriodSettingStream();

  return (dpm, MockParameterPageService());
}

(DpmService, ParameterPageService) _configureGraphQLServices() {
  return (GraphQLDpmService(), GraphQLParameterPageService());
}
