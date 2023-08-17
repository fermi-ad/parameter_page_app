import 'package:flutter/material.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/mock_parameter_page_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/theme/theme.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'services/dpm/dpm_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/dpm/graphql_dpm_service.dart';
import 'services/dpm/mock_dpm_service.dart';
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
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        body: _buildBody(context));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(title: _buildTitle(), actions: [
      Tooltip(
          message: "Display Settings",
          child: TextButton(
            key: const Key('display_settings_button'),
            child: const Text("Display Settings"),
            onPressed: () => _navigateToDisplaySettings(context),
          )),
    ]);
  }

  Widget _buildTitle() {
    return Row(key: const Key("page_title"), children: [
      Text(_title),
      const SizedBox(width: 8.0),
      _buildUnsavedChangesIndicator()
    ]);
  }

  Widget _buildUnsavedChangesIndicator() {
    return Visibility(
        visible: _pageHasUnsavedChanges,
        child: const Row(children: [
          Tooltip(
              key: Key("unsaved_changes_indicator"),
              message: "This page has unsaved changes.",
              child: Icon(Icons.warning, color: Colors.amber))
        ]));
  }

  Widget _buildBody(BuildContext context) {
    return _showLandingPage
        ? LandingPageWidget(
            onOpenPage: () => _navigateToOpenPage(context),
            onCreateNewPage: _startWithANewParameterPage,
          )
        : _buildPageWidget();
  }

  Widget _buildPageWidget() {
    return DataAcquisitionWidget(
        service: widget.dpmService,
        child: Center(
            child: PageWidget(
                key: _pageKey,
                service: widget.pageService,
                pageId: _openPageId,
                onPageModified: _handlePageModified)));
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(
            key: const Key("main_menu"),
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("Parameter Page Menu")),
              ListTile(title: const Text("New Page"), onTap: _handleNewPage),
              ListTile(
                  title: const Text("Open Page"),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToOpenPage(context);
                  }),
              ListTile(
                  title: const Text("Save"),
                  enabled: _pageHasUnsavedChanges,
                  onTap: _handleSavePage)
            ]));
  }

  void _startWithANewParameterPage() {
    setState(() {
      _openPageId = null;
      _showLandingPage = false;
      _title = "New Parameter Page";
    });
  }

  void _navigateToOpenPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OpenPageWidget(
              key: const Key("open_page_route"),
              onOpen: _handleOpenPage,
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

  void _handleSavePage() async {
    setState(() {
      _saving = true;
    });
  }

  void _handleNewPage() async {
    _scaffoldKey.currentState?.closeDrawer();

    await _pageKey.currentState?.newPage(onNewPage: () {
      setState(() {
        _title = "New Parameter Page";
        _openPageId = null;
      });
    });
  }

  void _handleOpenPage(String pageId, String pageTitle) async {
    setState(() {
      _title = pageTitle;
      _openPageId = pageId;
      _showLandingPage = false;
    });
  }

  void _handlePageModified(bool hasUnsavedChanges) {
    setState(() {
      _pageHasUnsavedChanges = hasUnsavedChanges;
    });
  }

  String _title = "Parameter Page";

  String? _openPageId;

  bool _showLandingPage = true;

  bool _pageHasUnsavedChanges = false;

  bool _saving = false;
}
