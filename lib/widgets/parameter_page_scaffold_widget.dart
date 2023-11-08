import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';
import 'package:parameter_page/widgets/display_settings_button_widget.dart';
import 'package:parameter_page/widgets/fermi_controls_common/error_display_widget.dart';
import 'package:parameter_page/widgets/main_menu_widget.dart';
import 'package:parameter_page/widgets/page_title_widget.dart';
import 'package:parameter_page/widgets/parameter_page_tabbar_widget.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
    } else if (_pageHasNotBeenLoadedYet() || _aDifferentPageShouldBeLoaded()) {
      _page = null;
      _loadPage(pageId: widget.openPageId!);
    } else if (_aNewPageShouldBeStarted()) {
      _page = ParameterPage();
      _page!.enableEditing();
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
            editing: _page?.editing ?? false,
            persistenceState: _persistenceState,
            title: _page == null ? "Parameter Page" : _page!.title,
            onTitleUpdate: _handleTitleUpdate),
        bottom: ParameterPageTabbarWidget(
            editing: _page?.editing ?? false,
            tabTitles: _page != null ? _page!.tabTitles : [],
            onDeleteTab: _handleDeleteTab,
            onCreateNewTab: _handleCreateNewTab,
            onRenameTab: _handleRenameTab,
            onTabSwitched: (String tabTitle) => setState(() {
                  _page!.switchTab(to: tabTitle);
                })),
        actions: [
          DisplaySettingsButtonWidget(
              wide: MediaQuery.of(context).size.width > 600,
              onPressed: () => _navigateToDisplaySettings(context)),
        ]);
  }

  Widget _buildBody(BuildContext context) {
    return _errorMessage != null
        ? _buildError(_errorMessage!)
        : _page == null
            ? _buildLoadingPage()
            : _buildPageWidget();
  }

  Widget _buildError(String detailMessage) {
    return ErrorDisplayWidget(
        key: const Key("parameter_page_error"),
        errorMessage:
            "The request to load the parameter page failed, please try again.",
        detailMessage: detailMessage);
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
      saveEnabled: _saveMenuShouldBeEnabled(),
      onCopyLink: _handleCopyLink,
      copyLinkEnabled: _page?.id != null,
    );
  }

  bool _saveMenuShouldBeEnabled() {
    return _persistenceState == PagePersistenceState.unsaved ||
        _persistenceState == PagePersistenceState.unsavedError;
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

  void _handleRenameTab(String withTitle, String to) {
    setState(() {
      _page!.renameTab(withTitle: withTitle, to: to);
    });
  }

  void _handleDeleteTab(String withTitle) {
    if (_page!.numberOfEntries(forTab: withTitle) > 0) {
      _promptUserToDeleteTab(context).then((bool? dialogResponse) {
        if (!(dialogResponse == null || !dialogResponse)) {
          _deleteTheTab(withTitle);
        }
      });
    } else {
      _deleteTheTab(withTitle);
    }
  }

  void _deleteTheTab(String withTitle) {
    setState(() {
      _page!.deleteTab(title: withTitle);
    });
  }

  void _handleCreateNewTab() {
    setState(() {
      _page!.createTab();
    });
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
      _savePageEntries(
          pageId: newId,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
            context.go("/page/$newId");
          });
    }).onError((error, stackTrace) {
      _handleSaveError(error, stackTrace);
    });
  }

  Future<void> _saveExistingPage({required Function() onSuccess}) async {
    try {
      await widget.pageService
          .renamePage(id: _page!.id!, newTitle: _page!.title);

      await _savePageEntries(
          pageId: _page!.id!,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
          });
    } catch (e, stackTrace) {
      _handleSaveError(e, stackTrace);
    }
  }

  Future<void> _savePageEntries(
      {required String pageId,
      required ParameterPage page,
      required Function onSuccess}) async {
    widget.pageService
        .savePage(
            id: pageId,
            page: page,
            onSuccess: () {
              page.commit();
              onSuccess.call();
            })
        .onError(_handleSaveError);
  }

  Future<void> _handleSaveError(error, stackTrace) async {
    setState(() {
      _persistenceState = PagePersistenceState.unsavedError;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Save failed - $error")));
  }

  _loadPage({required String pageId}) {
    widget.pageService
        .fetchPage(id: pageId)
        .then((ParameterPage page) => setState(() {
              _page = page;
            }))
        .onError((String error, stackTrace) => setState(() {
              _errorMessage = error;
              _page = null;
            }));
  }

  Future<bool?> _promptUserToDeleteTab(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        key: const Key("delete_tab_confirmation"),
        title: const Text('Delete Tab'),
        content: const Text(
            'This tab contains at least one entry.  Deleting the tab will discard all of it\'s entries.  Do you wish to continue?'),
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

  String? _errorMessage;

  ParameterPage? _page;

  PagePersistenceState _persistenceState = PagePersistenceState.clean;
}
