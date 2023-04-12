import 'package:flutter/material.dart';

import 'entry.dart';

class NewEntryEditorWidget extends StatefulWidget {
  final Function(PageEntry) onSubmitted;

  const NewEntryEditorWidget({super.key, required this.onSubmitted});

  @override
  State<NewEntryEditorWidget> createState() {
    return _NewEntryEditorState();
  }
}

class _NewEntryEditorState extends State<NewEntryEditorWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 1,
        minLines: 1,
        controller: controller,
        onSubmitted: (value) {
          setState(() {
            controller.text = "";
          });

          widget.onSubmitted(value == "Z:BDCCT"
              ? ParameterEntry(value,
                  label: "", key: const Key("parameter_row_Z:BDCCT"))
              : CommentEntry(value));
        });
  }
}
