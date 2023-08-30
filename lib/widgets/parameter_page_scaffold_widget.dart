import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';
import 'package:parameter_page/widgets/display_settings_button_widget.dart';
import 'package:parameter_page/widgets/main_menu_widget.dart';
import 'package:parameter_page/widgets/page_title_widget.dart';

import 'data_acquisition_widget.dart';
import 'display_settings_widget.dart';
import 'page_persistence_state_indicator_widget.dart';
import 'page_widget.dart';

class ParameterPageScaffoldWidget extends StatefulWidget {
  const ParameterPageScaffoldWidget(
      {super.key,
      required this.dpmService,
      required this.pageService,
      required this.deviceService,
      this.openPageId});

  final DpmService dpmService;

  final ParameterPageService pageService;

  final UserDeviceService deviceService;

  final String? openPageId;

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
    if (_pageHasNotBeenLoadedYet() || _aDifferentPageShouldBeLoaded()) {
      _page = null;
      _loadPage(pageId: widget.openPageId!);
    } else if (_aNewPageShouldBeStarted()) {
      _page = ParameterPage();
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        body: _buildBody(context));
  }

  bool _pageHasNotBeenLoadedYet() {
    return _page == null && widget.openPageId != null;
  }

  bool _aDifferentPageShouldBeLoaded() {
    return _page != null &&
        widget.openPageId != null &&
        widget.openPageId != _page!.id;
  }

  bool _aNewPageShouldBeStarted() {
    return _page == null && widget.openPageId == null;
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: PageTitleWidget(
            editing: _page?.editing() ?? false,
            persistenceState: _persistenceState,
            title: _page == null ? "Parameter Page" : _page!.title,
            onTitleUpdate: _handleTitleUpdate),
        actions: [
          DisplaySettingsButtonWidget(
              wide: MediaQuery.of(context).size.width > 600,
              onPressed: () => _navigateToDisplaySettings(context)),
        ]);
  }

  Widget _buildBody(BuildContext context) {
    return _page == null ? _buildLoadingPage() : _buildPageWidget();
  }

  Widget _buildPageWidget() {
    return DataAcquisitionWidget(
        service: widget.dpmService,
        child: Center(
            child: PageWidget(
                key: _pageKey,
                page: _page!,
                onPageModified: _handlePageModified,
                onToggleEditing: (bool isEditing) => setState(() {}))));
  }

  Widget _buildLoadingPage() {
    return const Row(children: [
      Spacer(),
      Column(key: Key("opening_page_progress_indicator"), children: [
        Spacer(),
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Loading..."),
        Spacer()
      ]),
      Spacer()
    ]);
  }

  Widget _buildDrawer(BuildContext context) {
    return MainMenuWidget(
      onNewPage: _handleNewPage,
      onOpenPage: (BuildContext context) => context.go("/open"),
      onSave: _handleSavePage,
      saveEnabled: _persistenceState == PagePersistenceState.unsaved,
      onCopyLink: _handleCopyLink,
      copyLinkEnabled: _page?.id != null,
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

  void _handleCopyLink() {
    final base = Uri.base.toString();
    widget.deviceService.setClipboard(to: base);
    _scaffoldKey.currentState?.closeDrawer();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Page URL copied to clipboard!")));
  }

  void _handleTitleUpdate(String newTitle) {
    if (newTitle != _page!.title) {
      setState(() {
        _page!.title = newTitle;
        _updatePersistenceState();
      });
    }
  }

  void _handleSavePage() async {
    _scaffoldKey.currentState?.closeDrawer();

    setState(() {
      _persistenceState = PagePersistenceState.saving;
    });

    _savePage(onSuccess: () {
      setState(() {
        _persistenceState = PagePersistenceState.saved;
      });
    });
  }

  void _handleNewPage() async {
    _scaffoldKey.currentState?.closeDrawer();

    if (_page?.isDirty ?? false) {
      _promptUserToDiscardChanges(context).then((bool? dialogResponse) {
        if (!(dialogResponse == null || !dialogResponse)) {
          context.go("/page");
        }
      });
    } else {
      context.go("/page");
    }
  }

  void _handlePageModified() {
    setState(() {
      _updatePersistenceState();
    });
  }

  void _updatePersistenceState() {
    if (_page?.isDirty ?? false) {
      _persistenceState = PagePersistenceState.unsaved;
    }
  }

  Future<void> _savePage({required Function() onSuccess}) async {
    if (_page!.id == null) {
      return _saveNewPage(onSuccess: onSuccess);
    } else {
      return _saveExistingPage(onSuccess: onSuccess);
    }
  }

  Future<void> _saveNewPage({required Function() onSuccess}) async {
    widget.pageService.createPage(withTitle: _page!.title).then((String newId) {
      widget.pageService.savePage(
          id: newId,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
            context.go("/page/$newId");
          });
    });
  }

  Future<void> _saveExistingPage({required Function() onSuccess}) async {
    widget.pageService
        .renamePage(id: _page!.id!, newTitle: _page!.title)
        .then((String newTitle) {
      widget.pageService.savePage(
          id: _page!.id!,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
          });
    });
  }

  _loadPage({required String pageId}) {
    widget.pageService
        .fetchPage(id: pageId)
        .then((ParameterPage page) => setState(() => _page = page));
  }

  Future<bool?> _promptUserToDiscardChanges(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text(
            'This page has unsaved changes that will be discarded.  Do you wish to continue?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  ParameterPage? _page;

  PagePersistenceState _persistenceState = PagePersistenceState.clean;
}
