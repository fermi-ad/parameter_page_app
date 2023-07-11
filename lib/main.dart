import 'package:flutter/material.dart';
import 'package:parameter_page/theme/theme.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'gql-dpm/graphql_dpm_service.dart';
import 'mock-dpm/mock_dpm_service.dart';
import 'page_entry.dart';
import 'widgets/page_widget.dart';

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
        drawer: _buildDrawer(context),
        body: _buildDPMService());
  }

  Widget _buildDPMService() {
    final child = Center(
        child: PageWidget(initialParameters: [
      ParameterEntry("M:OUTTMP@e,02",
          key: const Key("parameter_row_M:OUTTMP@e,02")),
      CommentEntry("This is our first comment!"),
      ParameterEntry("G:AMANDA", key: const Key("parameter_row_G:AMANDA")),
      ParameterEntry("Z:NO_ALARMS",
          key: const Key("parameter_row_Z:NO_ALARMS")),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Parameter Page Menu")),
          ListTile(
              title: const Text("Open Page"),
              onTap: () => _navigateToOpenPage(context))
        ]));
  }

  void _navigateToOpenPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OpenPageWidget(key: const Key("open_page_route"), onOpen: () {})),
    );
  }
}
