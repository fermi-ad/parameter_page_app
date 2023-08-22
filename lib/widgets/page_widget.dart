import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/widgets/new_entry_editor_widget.dart';
import '../entities/parameter_page.dart';
import '../entities/page_entry.dart';
import 'display_settings_widget.dart';

class DataSource extends InheritedWidget {
  final Stream<double> _data = Stream<double>.periodic(
    const Duration(seconds: 1),
    (count) {
      return 50.0 + count * 0.1;
    },
  ).asBroadcastStream();

  DataSource({required super.child, super.key});

  Stream<double>? stream() => _data;

  static DataSource of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataSource>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

// This widget implements the entire behavior of a "Parameter Page".

class PageWidget extends StatefulWidget {
  final ParameterPageService service;

  final String? pageId;

  final Function(bool)? onPageModified;

  final Function(bool)? onToggleEditing;

  const PageWidget(
      {this.pageId,
      this.onPageModified,
      this.onToggleEditing,
      required this.service,
      super.key});

  @override
  State<PageWidget> createState() => PageWidgetState();
}

// The non-public state of the Parameter Page.

class PageWidgetState extends State<PageWidget> {
  DisplaySettings settings = DisplaySettings();

  bool get pageIsLoading {
    return _page == null;
  }

  @override
  Widget build(BuildContext context) {
    _initializePage();

    return DataSource(
        child: LayoutBuilder(
      key: const Key("parameter_page_layout"),
      builder: (BuildContext context, BoxConstraints constraints) {
        return pageIsLoading
            ? _buildLoadingPage()
            : _buildPage(context, constraints.maxWidth > 600, _page!);
      },
    ));
  }

  Future<void> savePage(
      {required String title, required Function() onSuccess}) async {
    if (_page!.id == null) {
      return _saveNewPage(title: title, onSuccess: onSuccess);
    } else {
      return _saveExistingPage(
          title: title, pageId: _page!.id!, onSuccess: onSuccess);
    }
  }

  Future<void> _saveNewPage(
      {required String title, required Function() onSuccess}) async {
    widget.service.createPage(withTitle: title).then((String newId) {
      widget.service.savePage(
          id: newId,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
          });
      setState(() => _page!.id = newId);
    });
  }

  Future<void> _saveExistingPage(
      {required String pageId,
      required String title,
      required Function() onSuccess}) async {
    widget.service
        .renamePage(id: pageId, newTitle: title)
        .then((String newTitle) {
      widget.service.savePage(
          id: pageId,
          page: _page!,
          onSuccess: () {
            _page!.commit();
            onSuccess.call();
          });
    });
  }

  void _initializePage() {
    if (_pageNeedsToBeLoaded()) {
      _loadPage(pageId: widget.pageId!);
    } else if (_newPageIsRequested()) {
      _page = ParameterPage();
    }
  }

  bool _pageNeedsToBeLoaded() {
    return widget.pageId != null && (_page?.id != widget.pageId);
  }

  bool _newPageIsRequested() {
    return widget.pageId == null && _page == null;
  }

  Widget _buildLoadingPage() {
    return const Column(key: Key("opening_page_progress_indicator"), children: [
      Spacer(),
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text("Loading..."),
      Spacer()
    ]);
  }

  Widget _buildPage(BuildContext context, bool wide, ParameterPage page) {
    final bool movable = page.editing() && page.numberOfEntries > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ReorderableListView(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              footer: page.editing()
                  ? NewEntryEditorWidget(
                      key: const Key('add-entry-textfield'),
                      onSubmitted: (PageEntry newEntry) {
                        setState(() {
                          page.add(newEntry);
                        });
                      })
                  : null,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) =>
                  _reorderEntry(page, oldIndex, newIndex),
              children: page.entriesAsList().fold([], (acc, entry) {
                acc.add(Row(key: entry.key, children: [
                  Expanded(
                      child: _buildRow(context, entry, acc.length, wide, page)),
                  movable
                      ? ReorderableDragStartListener(
                          index: acc.length,
                          child: const Icon(Icons.drag_handle))
                      : Container()
                ]));
                return acc;
              })),
        ),
        _buildEditModeFloatingActionBar(page),
        _buildFloatingActionBar(page)
      ],
    );
  }

  Widget _buildRow(BuildContext context, PageEntry entry, int index, bool wide,
      ParameterPage page) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: page.editing()
          ? Row(children: [
              Expanded(
                  child: entry.buildEntry(
                      context, page.editing(), wide, settings)),
              const SizedBox(width: 8.0),
              GestureDetector(
                  onTap: () async {
                    var result = await _shouldDeleteRow(context);

                    if (result ?? false) {
                      setState(() {
                        page.removeEntry(at: index);
                      });
                    }
                  },
                  child: const IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: null,
                      icon: Icon(Icons.delete)))
            ])
          : entry.buildEntry(context, page.editing(), wide, settings),
    );
  }

  // Moves an entry from one location to another in the parameter list. It
  // also triggers a redraw.
  void _reorderEntry(ParameterPage onPage, oldIndex, newIndex) {
    setState(() {
      onPage.reorderEntry(atIndex: oldIndex, toIndex: newIndex);
    });
  }

  // Prompts the user to see if they want to remove a row. Return `true` or
  // `false` based on response.
  Future<bool?> _shouldDeleteRow(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Row'),
        content: const Text('Are you sure you want to delete the row?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionBar(ParameterPage page) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.small(
            key: const Key('enable_edit_mode_button'),
            heroTag: null,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withAlpha(page.editing() ? 255 : 128),
            onPressed: () => _toggleEditMode(page),
            child: const Icon(Icons.edit_note)));
  }

  void _toggleEditMode(ParameterPage page) {
    setState(() => page.toggleEditing());
    if (!page.editing()) {
      widget.onPageModified?.call(page.isDirty);
    }

    widget.onToggleEditing?.call(page.editing());
  }

  Widget _buildEditModeFloatingActionBar(ParameterPage page) {
    return Visibility(
        key: const Key("edit_mode_tools_visibility"),
        visible: page.editing(),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                  message: "Cancel",
                  child: FloatingActionButton.small(
                      key: const Key('cancel_edit_mode_button'),
                      heroTag: null,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(128),
                      onPressed: () => _cancelEditMode(page),
                      child: const Icon(Icons.restore)))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                  message: "Delete All",
                  child: FloatingActionButton.small(
                      key: const Key('clear_all_entries_button'),
                      heroTag: null,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withAlpha(128),
                      onPressed: () => _clearAllEntries(page),
                      child: const Icon(Icons.delete))))
        ]));
  }

  void _clearAllEntries(ParameterPage page) {
    setState(() => page.clearAll());
  }

  void _cancelEditMode(ParameterPage page) {
    setState(() => page.cancelEditing());
  }

  Future<void> newPage({Function()? onNewPage}) async {
    if (_page != null && _page!.isDirty) {
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
    widget.service.fetchEntries(
      forPageId: pageId,
      onFailure: (errorMessage) {
        throw UnimplementedError();
      },
      onSuccess: (fetchedEntries) {
        setState(() {
          _page = ParameterPage.fromQueryResult(fetchedEntries);
          _page!.id = pageId;
        });
      },
    );
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

  void updateSettings(DisplaySettings newSettings) {
    setState(() => settings = newSettings);
  }

  ParameterPage? _page;
}
