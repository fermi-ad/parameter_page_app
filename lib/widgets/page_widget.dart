import 'dart:async';
import 'package:flutter/material.dart';
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
  final ParameterPage page;

  final Function()? onPageModified;

  final Function(bool)? onToggleEditing;

  final bool settingsAllowed;

  const PageWidget(
      {required this.page,
      required this.settingsAllowed,
      this.onPageModified,
      this.onToggleEditing,
      super.key});

  @override
  State<PageWidget> createState() => PageWidgetState();
}

// The non-public state of the Parameter Page.

class PageWidgetState extends State<PageWidget> {
  DisplaySettings settings = DisplaySettings();

  @override
  Widget build(BuildContext context) {
    return DataSource(
        child: LayoutBuilder(
      key: const Key("parameter_page_layout"),
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildPage(
            context, MediaQuery.of(context).size.width > 600, widget.page);
      },
    ));
  }

  Widget _buildPage(BuildContext context, bool wide, ParameterPage page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildParameterList(page, wide)),
        _buildEditModeFloatingActionBar(page),
        _buildFloatingActionBar(page)
      ],
    );
  }

  ReorderableListView _buildParameterList(ParameterPage page, bool wide) {
    return ReorderableListView(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        footer: page.editing
            ? NewEntryEditorWidget(
                key: const Key('add-entry-textfield'),
                onSubmitted: (List<PageEntry> newEntries) {
                  setState(() {
                    page.addAll(newEntries);
                  });
                })
            : null,
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) =>
            _reorderEntry(page, oldIndex, newIndex),
        children: page.editing
            ? _buildRowsEditMode(page, wide)
            : _buildRowsDisplayMode(page, wide));
  }

  List<Widget> _buildRowsEditMode(ParameterPage page, bool wide) {
    final bool movable = page.numberOfEntries() > 1;

    List<Widget> acc = [];
    for (final entry in page.entriesAsList()) {
      acc.add(Row(key: entry.key, children: [
        Expanded(child: _buildEditRow([entry], wide, acc.length, page)),
        movable
            ? ReorderableDragStartListener(
                index: acc.length, child: const Icon(Icons.drag_handle))
            : Container()
      ]));
    }

    return acc;
  }

  List<Widget> _buildRowsDisplayMode(ParameterPage page, bool wide) {
    List<Widget> acc = [];

    for (List<PageEntry> entries in page.entriesAs2dList()) {
      acc.add(Row(key: entries[0].key, children: [
        Expanded(child: _buildDisplayRow(entries, wide, acc.length)),
        Container()
      ]));
    }

    return acc;
  }

  Widget _buildEditRow(
      List<PageEntry> entries, bool wide, int index, ParameterPage page) {
    final entry = entries[0];
    return Row(children: [
      Expanded(
          child: entry.buildEntry(context, true, wide, settings,
              widget.settingsAllowed, false, null, null)),
      const SizedBox(width: 8.0),
      GestureDetector(
          onTap: () async {
            setState(() {
              page.removeEntry(at: index);
            });
          },
          child: const IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: null,
              icon: Icon(Icons.delete)))
    ]);
  }

  Widget _buildDisplayRow(List<PageEntry> entries, bool wide, int index) {
    final entry = entries[0];

    if (entries.length > 1) {
      final multEntry = entry as MultEntry;
      multEntry.subEntries.clear();
      multEntry.subEntries.addAll(entries.sublist(1));
    }

    return TapRegion(
        onTapOutside: (event) => _handleNonPageEntryTap(),
        child: entry.buildEntry(
            context,
            false,
            wide,
            settings,
            widget.settingsAllowed,
            _focusRowIndex == index,
            () => _handlePageEntryTap(atIndex: index),
            null));
  }

  // Moves an entry from one location to another in the parameter list. It
  // also triggers a redraw.
  void _reorderEntry(ParameterPage onPage, oldIndex, newIndex) {
    setState(() {
      onPage.reorderEntry(atIndex: oldIndex, toIndex: newIndex);
    });
  }

  Widget _buildFloatingActionBar(ParameterPage page) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tooltip(
            message: page.editing ? "Stop editing" : "Edit this page",
            child: FloatingActionButton.small(
                key: const Key('enable_edit_mode_button'),
                heroTag: null,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(page.editing ? 255 : 128),
                onPressed: () => _toggleEditMode(page),
                child: const Icon(Icons.edit_note))));
  }

  void _toggleEditMode(ParameterPage page) {
    setState(() => page.toggleEditing());
    if (!page.editing) {
      widget.onPageModified?.call();
    }

    widget.onToggleEditing?.call(page.editing);
  }

  Widget _buildEditModeFloatingActionBar(ParameterPage page) {
    return Visibility(
        key: const Key("edit_mode_tools_visibility"),
        visible: page.editing,
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
                  message: "Delete all",
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

  void updateSettings(DisplaySettings newSettings) {
    setState(() => settings = newSettings);
  }

  void _handlePageEntryTap({required int atIndex}) {
    setState(
        () => _focusRowIndex = (_focusRowIndex == atIndex) ? null : atIndex);
  }

  void _handleNonPageEntryTap() {
    if (_focusRowIndex != null) {
      setState(() => _focusRowIndex = null);
    }
  }

  int? _focusRowIndex;
}
