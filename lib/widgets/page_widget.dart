import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parameter_page/parameter_page_service.dart';
import '../parameter_page.dart';
import '../page_entry.dart';
import 'display_settings_widget.dart';
import 'new_entry_editor_widget.dart';

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
  final List<PageEntry> initialParameters;

  final ParameterPageService service;

  const PageWidget(
      {required this.initialParameters, required this.service, super.key});

  @override
  State<PageWidget> createState() => PageWidgetState();
}

// The non-public state of the Parameter Page.

class PageWidgetState extends State<PageWidget> {
  late ParameterPage _page;

  DisplaySettings settings = DisplaySettings();

  @override
  void initState() {
    _page = ParameterPage(widget.initialParameters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataSource(
        child: LayoutBuilder(
      key: const Key("parameter_page_layout"),
      builder: (BuildContext context, BoxConstraints constraints) {
        return _build(context, constraints.maxWidth > 600);
      },
    ));
  }

  Widget _build(BuildContext context, bool wide) {
    final bool movable = _page.editing() && _page.numberOfEntries > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ReorderableListView(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              footer: _page.editing()
                  ? NewEntryEditorWidget(
                      key: const Key('add-entry-textfield'),
                      onSubmitted: (PageEntry newEntry) {
                        setState(() {
                          _page.add(newEntry);
                        });
                      })
                  : null,
              buildDefaultDragHandles: false,
              onReorder: _reorderEntry,
              children: _page.entriesAsList().fold([], (acc, entry) {
                acc.add(Row(key: entry.key, children: [
                  Expanded(child: _buildRow(context, entry, acc.length, wide)),
                  movable
                      ? ReorderableDragStartListener(
                          index: acc.length,
                          child: const Icon(Icons.drag_handle))
                      : Container()
                ]));
                return acc;
              })),
        ),
        _buildEditModeFloatingActionBar(),
        _buildFloatingActionBar()
      ],
    );
  }

  Widget _buildRow(
      BuildContext context, PageEntry entry, int index, bool wide) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _page.editing()
          ? Row(children: [
              Expanded(
                  child: entry.buildEntry(
                      context, _page.editing(), wide, settings)),
              const SizedBox(width: 8.0),
              GestureDetector(
                  onTap: () async {
                    var result = await _shouldDeleteRow(context);

                    if (result ?? false) {
                      setState(() {
                        _page.removeEntry(at: index);
                      });
                    }
                  },
                  child: const IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: null,
                      icon: Icon(Icons.delete)))
            ])
          : entry.buildEntry(context, _page.editing(), wide, settings),
    );
  }

  // Moves an entry from one location to another in the parameter list. It
  // also triggers a redraw.
  void _reorderEntry(oldIndex, newIndex) {
    setState(() {
      _page.reorderEntry(atIndex: oldIndex, toIndex: newIndex);
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

  Widget _buildFloatingActionBar() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.small(
            key: const Key('enable_edit_mode_button'),
            heroTag: null,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withAlpha(_page.editing() ? 255 : 128),
            onPressed: _toggleEditMode,
            child: const Icon(Icons.edit_note)));
  }

  void _toggleEditMode() {
    setState(() => _page.toggleEditing());
  }

  Widget _buildEditModeFloatingActionBar() {
    return Visibility(
        key: const Key("edit_mode_tools_visibility"),
        visible: _page.editing(),
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
                      onPressed: _cancelEditMode,
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
                      onPressed: _clearAllEntries,
                      child: const Icon(Icons.delete))))
        ]));
  }

  void _clearAllEntries() {
    setState(() => _page.clearAll());
  }

  void _cancelEditMode() {
    setState(() => _page.cancelEditing());
  }

  Future<void> newPage({Function()? onNewPage}) async {
    if (_page.isDirty) {
      final dialogResponse = await _shouldDiscardChanges(context);
      if (!(dialogResponse == null || !dialogResponse)) {
        setState(() => _page = ParameterPage());
        onNewPage?.call();
      }
    } else {
      setState(() => _page = ParameterPage());
      onNewPage?.call();
    }
  }

  Future<void> loadPage({required String pageId}) async {
    widget.service.fetchEntries(
      forPageId: pageId,
      onFailure: (errorMessage) {
        throw UnimplementedError();
      },
      onSuccess: (fetchedEntries) {
        setState(() {
          _page = ParameterPage.fromQueryResult(fetchedEntries);
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
}
