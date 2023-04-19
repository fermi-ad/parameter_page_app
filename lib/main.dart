import 'package:flutter/material.dart';
import 'package:parameter_page/theme/theme.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'gql-dpm/graphql_dpm_service.dart';
import 'mock-dpm/mock_dpm_service.dart';
import 'page/entry.dart';
import 'page/page.dart';

void main() {
  const useMockServices =
      String.fromEnvironment("USE_MOCK_DPM_SERVICE", defaultValue: "false") !=
          "false";

  runApp(const FermiApp(
      title: "Parameter Page",
      child: BaseWidget(
          title: 'Parameter Page', useMockServices: useMockServices)));
}

// This is the base widget for the app. It's only purpose is to provide
// consistent theme settings to the rest of the app. All apps using this
// base widget will have a similar look-and-feel.

class FermiApp extends StatelessWidget {
  final String title;
  final Widget child;

  const FermiApp({required this.title, required this.child, super.key});

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

class BaseWidget extends StatelessWidget {
  const BaseWidget(
      {super.key, this.useMockServices = false, required this.title});

  final bool useMockServices;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body:
            _buildDPMService()); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget _buildDPMService() {
    final child = Center(
        child: PageWidget(initialParameters: [
      ParameterEntry("M:OUTTMP@e,02",
          key: const Key("parameter_row_M:OUTTMP@e,02")),
      CommentEntry("This is our first comment!"),
      ParameterEntry("G:AMANDA", key: const Key("parameter_row_G:AMANDA")),
      ParameterEntry("PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
          key: const Key(
              "parameter_row_PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE")),
      ParameterEntry("PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:HUMIDITY",
          key: const Key(
              "parameter_row_PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:HUMIDITY"),
          label: "Humidity"),
    ]));

    return useMockServices
        ? DataAcquisitionWidget(service: const MockDpmService(), child: child)
        : DataAcquisitionWidget(service: GraphQLDpmService(), child: child);
  }
}
