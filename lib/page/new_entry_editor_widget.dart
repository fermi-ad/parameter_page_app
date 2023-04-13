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
    if (_isACNETDRF(textInput) || _isProcessVariable(textInput)) {
      return ParameterEntry(textInput,
          label: "", key: Key("parameter_row_$textInput"));
    } else if (_isHardComment(textInput)) {
      return CommentEntry(_stripBang(textInput));
    } else {
      return CommentEntry(textInput);
    }
  }

  bool _isHardComment(String val) {
    return "!" == val[0];
  }

  bool _isACNETDRF(String val) {
    var drfRegEx = RegExp(r"^[A-Za-z][:_|][A-Za-z0-9@,]{1,255}$");

    return drfRegEx.hasMatch(val);
  }

  bool _isProcessVariable(String val) {
    var pvRegEx = RegExp(r"^([A-Za-z0-9:]{1,255})$");

    return pvRegEx.hasMatch(val);
  }

  String _stripBang(String textInput) {
    return textInput.substring(1);
  }
}
