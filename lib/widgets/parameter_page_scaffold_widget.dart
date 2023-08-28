import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
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
      this.openPageId});

  final DpmService dpmService;

  final ParameterPageService pageService;

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
  void initState() {
    if (widget.openPageId != null) {
      _loadPage(pageId: widget.openPageId!);
    } else {
      _page = ParameterPage();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context),
        body: _buildBody(context));
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
        onOpenPage: _navigateToOpenPage,
        onSave: _handleSavePage,
        saveEnabled: _persistenceState == PagePersistenceState.unsaved);
  }

  void _navigateToOpenPage(BuildContext context) {
    context.go("/open");
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

    await _newPage(onNewPage: () {
      setState(() {
        _persistenceState = PagePersistenceState.clean;
      });
    });
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
          });
      setState(() => _page!.id = newId);
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

  Future<void> _newPage({Function()? onNewPage}) async {
    if (_page?.isDirty ?? false) {
      final dialogResponse = await _shouldDiscardChanges(context);
      if (!(dialogResponse == null || !dialogResponse)) {
        setState(() {
          _page = ParameterPage();
        });
        onNewPage?.call();
      }
    } else {
      setState(() {
        _page = ParameterPage();
      });
      onNewPage?.call();
    }
  }

  _loadPage({required String pageId}) {
    setState(() => _page = null);
    widget.pageService
        .fetchPage(id: pageId)
        .then((ParameterPage page) => setState(() => _page = page));
  }

  // Prompts the user to see if they want to discard changes to the page.
  // Return `true` or `false` based on response.
  Future<bool?> _shouldDiscardChanges(BuildContext context) {
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
