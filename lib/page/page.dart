import 'dart:async';
import 'package:flutter/material.dart';
import 'entry.dart';
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
  final List<PageEntry> parameters;

  const PageWidget(this.parameters, {super.key});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

// The non-public state of the Parameter Page.

class _PageWidgetState extends State<PageWidget> {
  bool editMode = false;
  List<PageEntry> parameters = [];
  List<PageEntry> _undoParameters = [];

  // Initialize the state by copying the parameters sent it.

  @override
  void initState() {
    parameters = widget.parameters.toList();
    super.initState();
  }

  // Moves an entry from one location to another in the parameter list. It
  // also triggers a redraw.

  void reorderEntry(oldIndex, newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final PageEntry item = parameters.removeAt(oldIndex);
      parameters.insert(newIndex, item);
    });
  }

  // Prompts the user to see if they want to remove a row. Return `true` or
  // `false` based on response.

  Future<bool?> shouldDeleteRow(BuildContext context) {
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

  // Builds a single row of the parameter page.

  Widget buildRow(BuildContext context, PageEntry entry, int index, bool wide) {
    return GestureDetector(
        onTap: () async {
          var result = await shouldDeleteRow(context);

          if (result ?? false) {
            setState(() {
              parameters.removeAt(index);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: editMode
              ? Row(children: [
                  Expanded(child: entry.buildEntry(context, editMode, wide)),
                  const SizedBox(width: 8.0),
                  const IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: null,
                      icon: Icon(Icons.delete))
                ])
              : entry.buildEntry(context, editMode, wide),
        ));
  }

  // Build the widget for wide screens.

  Widget _build(BuildContext context, bool wide) {
    final bool movable = editMode && parameters.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ReorderableListView(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              footer: editMode
                  ? NewEntryEditorWidget(
                      key: const Key('add-entry-textfield'),
                      onSubmitted: (value) {
                        setState(() => parameters.add(CommentEntry(value)));
                      })
                  : null,
              buildDefaultDragHandles: false,
              onReorder: reorderEntry,
              children: parameters.fold([], (acc, entry) {
                acc.add(Row(key: entry.key, children: [
                  Expanded(child: buildRow(context, entry, acc.length, wide)),
                  movable
                      ? ReorderableDragStartListener(
                          index: acc.length,
                          child: const Icon(Icons.drag_handle))
                      : Container()
                ]));
                return acc;
              })),
        ),
        Visibility(
            key: const Key("cancel_edit_mode_button_visibility"),
            visible: editMode,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.small(
                    key: const Key('cancel_edit_mode_button'),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withAlpha(128),
                    onPressed: _cancelEditMode,
                    child: const Icon(Icons.delete)))),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.small(
                key: const Key('enable_edit_mode_button'),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(editMode ? 255 : 128),
                onPressed: _toggleEditMode,
                child: const Icon(Icons.settings)))
      ],
    );
  }

  void _cancelEditMode() {
    _restoreEntries();
    setState(() => editMode = false);
  }

  void _restoreEntries() {
    setState(() => parameters = List<PageEntry>.from(_undoParameters));
  }

  void _toggleEditMode() {
    if (!editMode) {
      _saveEntries();
    }
    setState(() => editMode = !editMode);
  }

  void _saveEntries() {
    _undoParameters = List<PageEntry>.from(parameters);
  }

  @override
  Widget build(BuildContext context) {
    return DataSource(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _build(context, constraints.maxWidth > 600);
      },
    ));
  }
}
