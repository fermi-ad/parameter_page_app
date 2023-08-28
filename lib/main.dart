import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/widgets/fermi_controls_common/fermi_controls_app.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'package:parameter_page/widgets/parameter_page_scaffold_widget.dart';
import 'services/dpm/dpm_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/graphql_dpm_service.dart';
import 'services/dpm/mock_dpm_service.dart';

String openTitle = "";

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService) = _configureServices();

  runApp(FermiControlsApp(
      title: "Parameter Page",
      router: GoRouter(routes: _configureRoutes(dpmService, pageService))));
}

List<GoRoute> _configureRoutes(
    DpmService dpmService, ParameterPageService pageService) {
  return [
    GoRoute(
        name: "LandingPage",
        path: "/",
        builder: (context, state) => LandingPageWidget(
              onOpenPage: () => context.go("/open"),
              onCreateNewPage: () => context.go("/page"),
            )),
    GoRoute(
        name: "OpenParameterPage",
        path: "/open",
        builder: (context, state) => OpenPageWidget(
            key: const Key("open_page_route"),
            onOpen: (id, title) {
              openTitle = title;
              context.go("/page/$id");
            },
            service: pageService)),
    GoRoute(
        name: "NewParameterPage",
        path: "/page",
        builder: (context, state) => ParameterPageScaffoldWidget(
            dpmService: dpmService, pageService: pageService)),
    GoRoute(
        name: "DisplayParameterPage",
        path: "/page/:id",
        builder: (context, state) => ParameterPageScaffoldWidget(
            dpmService: dpmService,
            pageService: pageService,
            title: openTitle,
            openPageId: state.pathParameters['id']))
  ];
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
