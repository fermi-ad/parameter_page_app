import 'package:flutter/material.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/theme/theme.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'services/dpm/dpm_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/graphql_dpm_service.dart';
import 'services/dpm/mock_dpm_service.dart';
import 'entities/page_entry.dart';
import 'widgets/page_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  var (dpmService, pageService) = _configureServices();

  runApp(FermiApp(
      title: "Parameter Page",
      child: BaseWidget(dpmService: dpmService, pageService: pageService)));
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

class BaseWidget extends StatefulWidget {
  const BaseWidget(
      {super.key, required this.dpmService, required this.pageService});

  final DpmService dpmService;

  final ParameterPageService pageService;

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final _pageKey = GlobalKey<PageWidgetState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Container(key: const Key("page_title"), child: Text(_title)),
            actions: [
              Tooltip(
                  message: "Display Settings",
                  child: TextButton(
                    key: const Key('display_settings_button'),
                    child: const Text("Display Settings"),
                    onPressed: () => _navigateToDisplaySettings(context),
                  )),
            ]),
        drawer: _buildDrawer(context),
        body: _buildDPMService());
  }

  Widget _buildDPMService() {
    final child = Center(
        child: PageWidget(
            key: _pageKey,
            service: widget.pageService,
            initialParameters: [
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
          ParameterEntry("Z:BTE200_TEMP",
              key: const Key("parameter_row_BTE200_TEMP")),
          ParameterEntry("Z:INC_SETTING",
              key: const Key("parameter_row_Z:INC_SETTING"))
        ]));

    return DataAcquisitionWidget(service: widget.dpmService, child: child);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Parameter Page Menu")),
          ListTile(title: const Text("New Page"), onTap: _newPage),
          ListTile(
              title: const Text("Open Page"),
              onTap: () => _navigateToOpenPage(context))
        ]));
  }

  void _newPage() async {
    await _pageKey.currentState?.newPage(
        onNewPage: () => setState(() => _title = "New Parameter Page"));
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _navigateToOpenPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OpenPageWidget(
              key: const Key("open_page_route"),
              onOpen: (String pageId, String pageTitle) =>
                  _handleOpenPage(context, pageId, pageTitle),
              service: widget.pageService)),
    );
  }

  void _navigateToDisplaySettings(BuildContext context) {
    final initialSettings = _pageKey.currentState != null
        ? _pageKey.currentState!.settings
        : DisplaySettings();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplaySettingsWidget(
                  initialSettings: initialSettings,
                  key: const Key("display_settings_route"),
                  onChanged: (DisplaySettings newSettings) =>
                      _pageKey.currentState?.updateSettings(newSettings),
                )));
  }

  void _handleOpenPage(
      BuildContext context, String pageId, String pageTitle) async {
    _pageKey.currentState?.loadPage(pageId: pageId);
    Navigator.pop(context);
    setState(() => _title = pageTitle);
  }

  String _title = "Parameter Page";
}
