import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'entry.dart';

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
  TextEditingController controller = TextEditingController();

  // Initialize the state by copying the parameters sent it.

  @override
  void initState() {
    parameters = widget.parameters.toList();
    super.initState();
  }

  // When the widget is being destroyed, free up resources associated with the
  // text editing controller.

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Creates the editor used to add new entries.

  Widget newEntryEditor() {
    return TextField(
        maxLines: 1,
        minLines: 1,
        key: const Key('add-entry-textfield'),
        controller: controller,
        onSubmitted: (value) {
          setState(() {
            parameters.add(CommentEntry(value));
            controller.text = "";
          });
        });
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

  Widget buildRow(BuildContext context, PageEntry entry, int index,
      double rightPadding, bool wide) {
    return GestureDetector(
        key: entry.key,
        onTap: () async {
          var result = await shouldDeleteRow(context);

          if (result ?? false) {
            setState(() {
              parameters.removeAt(index);
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(2.0, 2.0, rightPadding, 2.0),
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
    final double rightPadding = (movable &&
            TargetPlatformVariant.desktop()
                .values
                .contains(Theme.of(context).platform))
        ? 40.0
        : 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ReorderableListView(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              footer: editMode ? newEntryEditor() : null,
              buildDefaultDragHandles: movable,
              onReorder: reorderEntry,
              children: parameters.fold([], (acc, entry) {
                acc.add(
                    buildRow(context, entry, acc.length, rightPadding, wide));
                return acc;
              })),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.small(
              key: const Key('enable_edit_mode_button'),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha(editMode ? 255 : 128),
              child: const Icon(Icons.settings),
              onPressed: () => setState(() => editMode = !editMode)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _build(context, constraints.maxWidth > 600);
      },
    );
  }
}
