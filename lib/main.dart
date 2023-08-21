import 'package:flutter/material.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/theme/theme.dart';
import 'package:parameter_page/widgets/parameter_page_scaffold_widget.dart';
import 'services/dpm/dpm_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/graphql_dpm_service.dart';
import 'services/dpm/mock_dpm_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService) = _configureServices();

  runApp(FermiControlsApp(
      title: "Parameter Page",
      child: ParameterPageScaffoldWidget(
          dpmService: dpmService, pageService: pageService)));
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

// This is the base widget for the app. It's only purpose is to provide
// consistent theme settings to the rest of the app. All apps using this
// base widget will have a similar look-and-feel.

class FermiControlsApp extends StatelessWidget {
  final String title;
  final Widget child;

  const FermiControlsApp({required this.title, required this.child, super.key});

  // Return the MaterialApp widget which will define the look-and-feel for the
  // application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: GlobalAppTheme.lightTheme,
      darkTheme: GlobalAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SelectionArea(child: child),
    );
  }
}
