import 'package:flutter/material.dart';
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      setState(() {
                        parameters.insert(0, CommentEntry(value));
                        controller.text = "";
                      });
                    })),
          ],
        ),
        Expanded(
          child: ListView(
              children: parameters.fold([], (acc, entry) {
            final index = acc.length;

            acc.add(GestureDetector(
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
                  padding: const EdgeInsets.all(2.0),
                  child: entry.buildEntry(context),
                )));

            return acc;
          })),
        ),
      ],
    );
  }
}
