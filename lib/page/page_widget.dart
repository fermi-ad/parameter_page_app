import 'dart:async';
import 'package:flutter/material.dart';
import '../parameter_page.dart';
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
  final List<PageEntry> initialParameters;

  const PageWidget({required this.initialParameters, super.key});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

// The non-public state of the Parameter Page.

class _PageWidgetState extends State<PageWidget> {
  late ParameterPage _page;

  // Initialize the state by copying the parameters sent it.

  @override
  void initState() {
    _page = ParameterPage(widget.initialParameters);
    super.initState();
  }

  // Moves an entry from one location to another in the parameter list. It
  // also triggers a redraw.

  void reorderEntry(oldIndex, newIndex) {
    setState(() {
      _page.reorderEntry(atIndex: oldIndex, toIndex: newIndex);
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
              _page.removeEntry(at: index);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: _page.editing()
              ? Row(children: [
                  Expanded(
                      child: entry.buildEntry(context, _page.editing(), wide)),
                  const SizedBox(width: 8.0),
                  const IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: null,
                      icon: Icon(Icons.delete))
                ])
              : entry.buildEntry(context, _page.editing(), wide),
        ));
  }

  // Build the widget for wide screens.

  Widget _build(BuildContext context, bool wide) {
    final bool movable = _page.editing() && _page.numberOfEntries() > 1;

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
              onReorder: reorderEntry,
              children: _page.entriesAsList().fold([], (acc, entry) {
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
            visible: _page.editing(),
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
                    .withAlpha(_page.editing() ? 255 : 128),
                onPressed: _toggleEditMode,
                child: const Icon(Icons.settings)))
      ],
    );
  }

  void _cancelEditMode() {
    setState(() => _page.cancelEditing());
  }

  void _toggleEditMode() {
    setState(() => _page.toggleEditing());
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