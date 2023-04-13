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

          widget.onSubmitted(_generatePageEntryFrom(textInput: value));
        });
  }

  PageEntry _generatePageEntryFrom({required final String textInput}) {
    return _isComment(textInput)
        ? CommentEntry(textInput)
        : ParameterEntry(textInput,
            label: "", key: Key("parameter_row_$textInput"));
  }

  bool _isComment(String val) {
    return !(val == "Z:BDCCT" || val == "I:BEAM" || val == "EXAMPLE:EPICS:PV");
  }
}
