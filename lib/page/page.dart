import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'entry.dart';

class PageWidget extends StatefulWidget {
  final List<PageEntry> parameters;

  const PageWidget(this.parameters, {super.key});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  List<PageEntry> parameters = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    parameters = widget.parameters.toList();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool movable = parameters.length > 1;
    final double rightPadding = (movable &&
            TargetPlatformVariant.desktop()
                .values
                .contains(Theme.of(context).platform))
        ? 40.0
        : 2.0;

    return Center(
      child: ReorderableListView(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
          header: TextField(
              maxLines: 1,
              minLines: 1,
              key: const Key('add-entry-textfield'),
              controller: controller,
              onSubmitted: (value) {
                setState(() {
                  parameters.insert(0, CommentEntry(value));
                  controller.text = "";
                });
              }),
          buildDefaultDragHandles: movable,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final PageEntry item = parameters.removeAt(oldIndex);
              parameters.insert(newIndex, item);
            });
          },
          children: parameters.fold([], (acc, entry) {
            final index = acc.length;

            acc.add(GestureDetector(
                key: entry.key,
                onTap: () async {
                  var result = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete Row'),
                      content: const Text(
                          'Are you sure you want to delete the row?'),
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

                  if (result ?? false) {
                    setState(() {
                      parameters.removeAt(index);
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(2.0, 2.0, rightPadding, 2.0),
                  child: entry.buildEntry(context),
                )));

            return acc;
          })),
    );
  }
}
