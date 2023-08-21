import 'package:flutter/material.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

import 'data_acquisition_widget.dart';
import 'display_settings_widget.dart';
import 'landing_page_widget.dart';
import 'open_page_widget.dart';
import 'page_persistence_state_indicator_widget.dart';
import 'page_widget.dart';

class ParameterPageScaffoldWidget extends StatefulWidget {
  const ParameterPageScaffoldWidget(
      {super.key, required this.dpmService, required this.pageService});

  final DpmService dpmService;

  final ParameterPageService pageService;

  @override
  State<ParameterPageScaffoldWidget> createState() =>
      _ParameterPageScaffoldWidgetState();
}

class _ParameterPageScaffoldWidgetState
    extends State<ParameterPageScaffoldWidget> {
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
      PagePersistenceStateIndicatorWidget(persistenceState: _persistenceState)
    ]);
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
                  enabled: _persistenceState == PagePersistenceState.unsaved,
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
    _scaffoldKey.currentState?.closeDrawer();

    setState(() {
      _persistenceState = PagePersistenceState.saving;
    });

    _pageKey.currentState?.savePage(onSuccess: () {
      setState(() {
        _persistenceState = PagePersistenceState.saved;
      });
    });
  }

  void _handleNewPage() async {
    _scaffoldKey.currentState?.closeDrawer();

    await _pageKey.currentState?.newPage(onNewPage: () {
      setState(() {
        _title = "New Parameter Page";
        _openPageId = null;
        _persistenceState = PagePersistenceState.clean;
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

  void _handlePageModified(PagePersistenceState newPersistenceState) {
    setState(() {
      _persistenceState = newPersistenceState;
    });
  }

  String _title = "Parameter Page";

  String? _openPageId;

  bool _showLandingPage = true;

  PagePersistenceState _persistenceState = PagePersistenceState.clean;
}
